{ ******************************************************************************
  Copyright 2017 Marcos Santos

  Contact: marcos.santos@outlook.com

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  *****************************************************************************}

unit Glue.DataManager;

interface
uses
   Rtti,
   System.Classes,
   Generics.Collections,
   Glue.View.Vcl,
   Glue.Observer,
   Glue.ActionListener,
   Glue.Attributes,
   Glue.AttributeUtils,
   Glue.Binding,
   Glue.Binding.Impl.Binding,
   Glue.Binding.Command,
   Glue.Binding.Impl.Command,
   Glue.Converter,
   Glue.Converter.Impl.GenericConverter;

type

   IDataManager = interface
      ['{A6F7EA3E-F862-446F-9BD5-B8B66FDD4A9C}']
      procedure ReleaseData();
   end;

   TDataManager = class(TInterfacedObject, IDataManager, IActionListener)
   private
      FView : TComponent;
      FViewModel : TObject;
      FBinders : TDictionary<String, IBinding>;
      FCommands : TDictionary<String, ICommand>;
      Fvmi: TVirtualMethodInterceptor;
   private
      procedure DataBinding();
      procedure AddBind(Field: TRttiField; Attr: TBindBaseAttribute);
      procedure AddCommand(Field: TRttiField; Attr: CommandAttribute);
      procedure AddTemplate(Field: TRttiField; Attr: TemplateAttribute);
      function GetConverter(Field: TRttiField) : IConverter;
      procedure OnAfter(Instance: TObject; Method: TRttiMethod; const Args: TArray<TValue>; var Result: TValue);
   public
      constructor Create(View : TComponent; ViewModel : TObject);
      destructor Destroy; override;
      procedure Update(const PropertyName: string); overload;
      procedure Update(const PropertiesNames : TArray<string>); overload;
      procedure OnBeforeAction(ActionName : String);
      procedure OnAfterAction(ActionName : String);
      procedure ReleaseData();
   end;

implementation
uses Glue, System.SysUtils;

{ TDataBinding }

procedure TDataManager.AddBind(Field: TRttiField; Attr: TBindBaseAttribute);
var
   Binding : IBinding;
   Converter : IConverter;
begin

   Converter := GetConverter(Field);

   Binding := TBinding.Create(Attr.Mode, FView.FindComponent(Field.Name), FViewModel, Converter, Attr.BindContext);

   FBinders.Add(Attr.BindContext.AttributeVM, Binding);

end;

procedure TDataManager.AddCommand(Field: TRttiField; Attr: CommandAttribute);
var
   Command : ICommand;
begin

   Command := TCommand.Create(FView.FindComponent(Field.Name), FViewModel, Attr.TriggerName, Attr.HandlerName);

   FCommands.Add(Attr.HandlerName, Command);

end;

procedure TDataManager.AddTemplate(Field: TRttiField; Attr: TemplateAttribute);
var
   Component : TComponent;
begin

   Component := FView.FindComponent(Field.Name);

   if Component is TComboBox then
      TComboBox(Component).Template := Attr.Expression
   else
      raise Exception.Create('Unsupported template exception');

end;

constructor TDataManager.Create(View: TComponent;
  ViewModel: TObject);
begin

   FView := View;

   FViewModel := ViewModel;

   FBinders := TDictionary<String, IBinding>.Create;

   FCommands := TDictionary<String, ICommand>.Create;

   Fvmi := TVirtualMethodInterceptor.Create(FViewModel.ClassType);

   Fvmi.OnAfter := OnAfter;

   Fvmi.Proxify(FViewModel);

   DataBinding;

   Update('*');

end;

procedure TDataManager.DataBinding;
var
   ctx: TRttiContext;
   objType: TRttiType;
   Field: TRttiField;
   Attr: TCustomAttribute;
begin

   ctx := TRttiContext.Create;
   objType := ctx.GetType(FView.ClassType);

   for Field in objType.GetFields do
   begin

      for Attr in Field.GetAttributes do
      begin

         if Attr is TBindBaseAttribute then
         begin
            AddBind(Field, TBindBaseAttribute(Attr));
            continue;
         end;

         if Attr is CommandAttribute then
         begin
            AddCommand(Field, CommandAttribute(Attr));
            continue;
         end;

         if Attr is TemplateAttribute then
         begin
            AddTemplate(Field, TemplateAttribute(Attr));
            continue;
         end;

      end;

   end;

end;

destructor TDataManager.Destroy;
begin

   FBinders.Free;

   FCommands.Free;

   Fvmi.Free;

   inherited;
end;

function TDataManager.GetConverter(Field: TRttiField): IConverter;
var
   Attr: TCustomAttribute;
   ConverterName : String;
begin

   ConverterName := 'default';

   for Attr in Field.GetAttributes do
   begin

      if Attr is ConverterAttribute then
      begin
         ConverterName :=  ConverterAttribute(Attr).ClassName;
         break;
      end;

   end;

   if ConverterName.Equals('default') then
      Exit(TGenericConverter.Create);

   Result := TInterfacedObject(TGlue.GetInstance.Resolve(ConverterName)) as IConverter;

end;

procedure TDataManager.OnAfter(Instance: TObject; Method: TRttiMethod;
  const Args: TArray<TValue>; var Result: TValue);
var
   Attribute : NotifyChange;
begin

   Attribute := TAttributeUtils.GetAttribute<NotifyChange>(Method);

   if Assigned(Attribute) then
      Update(Attribute.PropertiesNames);

end;

procedure TDataManager.OnAfterAction(ActionName: String);
begin

end;

procedure TDataManager.OnBeforeAction(ActionName: String);
begin

end;

procedure TDataManager.ReleaseData;
var
   Command : ICommand;
begin

   for Command in FCommands.Values.ToArray do
      Command.Detach(Self);

end;

procedure TDataManager.Update(const PropertiesNames: TArray<string>);
var
   Value : String;
begin

   for Value in PropertiesNames do
      Update(Value);

end;

procedure TDataManager.Update(const PropertyName: string);
var
   Binder : IBinding;
begin

   if PropertyName.Equals('*') then
   begin

      for Binder in FBinders.Values.ToArray do
         Binder.LoadData;

      Exit;
   end;

   if not FBinders.ContainsKey(PropertyName) then
      Exit;

   Binder := FBinders.Items[PropertyName];

   Binder.LoadData;

end;

end.
