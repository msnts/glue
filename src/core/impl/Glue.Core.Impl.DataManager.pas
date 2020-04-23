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
  ***************************************************************************** }

unit Glue.Core.Impl.DataManager;

interface

uses
  Rtti,
  System.Classes,
  System.SysUtils,
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
  Glue.Converter.Impl.GenericConverter,
  Glue.Core.DataManager,
  Glue.Core.BinderStore,
  Glue.Core.Impl.BinderStore;

type

  TDataManager = class(TInterfacedObject, IDataManager, IActionListener)
  private
    FView: TComponent;
    FViewModel: TObject;
    FBinders: IBinderStore;
    FCommands: TDictionary<string, ICommand>;
    Fvmi: TVirtualMethodInterceptor;
    FViewType: TRttiType;
    FViewModelType: TRttiType;
    FInitialMethod: TRttiMethod;
  private
    procedure AnalyzeViewModel;
    procedure DataBinding();
    procedure AddBind(Field: TRttiField; Attr: TBindBaseAttribute);
    procedure AddCommand(Field: TRttiField; Attr: CommandAttribute);
    procedure AddTemplate(Field: TRttiField; Attr: TemplateAttribute);
    function GetConverter(Field: TRttiField): IConverter;
    procedure InitializeViewModel;
    procedure OnAfter(Instance: TObject; Method: TRttiMethod; const Args: TArray<TValue>; var Result: TValue);
  public
    constructor Create(View: TComponent; ViewModel: TObject);
    destructor Destroy; override;
    procedure Apply();
    procedure Update(const PropertyName: string); overload;
    procedure Update(const PropertiesNames: TArray<string>); overload;
    procedure OnBeforeAction(ActionName: string);
    procedure OnAfterAction(ActionName: string);
    procedure ReleaseData();
  end;

implementation
uses Glue;

{ TDataBinding }

procedure TDataManager.AddBind(Field: TRttiField; Attr: TBindBaseAttribute);
var
  Binding: IBinding;
  Converter: IConverter;
begin

  Converter := GetConverter(Field);

  Binding := TBinding.Create(FViewModelType, FViewModel,
    Attr.SourcePropertyName, FViewType, FView, Attr.TargetPropertyName,
    Attr.BindingMode, Converter);

  FBinders.Add(Attr.SourcePropertyName, Binding);

end;

procedure TDataManager.AddCommand(Field: TRttiField; Attr: CommandAttribute);
var
  Command: ICommand;
begin

  Command := TCommand.Create(FViewModelType, FViewModel, FViewType, FView,
    Attr.TriggerName, Attr.HandlerName);

  FCommands.Add(Attr.HandlerName, Command);

end;

procedure TDataManager.AddTemplate(Field: TRttiField; Attr: TemplateAttribute);
var
  Component: TComponent;
begin

  Component := FView.FindComponent(Field.Name);

  if Component is TComboBox then
    TComboBox(Component).Template := Attr.Expression
  else
    raise Exception.Create('Unsupported template exception');

end;

procedure TDataManager.AnalyzeViewModel;
var
  FField: TRttiField;
  LMethod: TRttiMethod;
  LAttrib: TCustomAttribute;
  Value: TValue;
begin
  for FField in FViewModelType.GetFields do
  begin
    for LAttrib in FField.GetAttributes do
    begin
      if LAttrib is WireVariable then
      begin
        Value := TValue.From<Tobject>(TGlue.GetInstance.Resolve('DialogService'));
        FField.SetValue(FViewModel, Value);
      end;
    end;
  end;

  for LMethod in FViewModelType.GetMethods do
  begin
    for LAttrib in LMethod.GetAttributes do
    begin
      if LAttrib is InitAttribute then
        FInitialMethod := LMethod;
    end;
  end;
end;

procedure TDataManager.Apply;
begin
  InitializeViewModel();
  Update('*');
end;

constructor TDataManager.Create(View: TComponent; ViewModel: TObject);
begin
  FView := View;

  FViewModel := ViewModel;

  FBinders := TBinderStore.Create;

  FCommands := TDictionary<string, ICommand>.Create;

  Fvmi := TVirtualMethodInterceptor.Create(FViewModel.ClassType);

  Fvmi.OnAfter := OnAfter;

  Fvmi.Proxify(FViewModel);

  DataBinding;

  AnalyzeViewModel;
end;

procedure TDataManager.DataBinding;
var
  ctx: TRttiContext;
  Field: TRttiField;
  Attr: TCustomAttribute;
begin

  ctx := TRttiContext.Create;
  FViewType := ctx.GetType(FView.ClassType);
  FViewModelType := ctx.GetType(FViewModel.ClassType);

  for Field in FViewType.GetFields do
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
  FCommands.Free;

  Fvmi.Free;

  inherited;
end;

function TDataManager.GetConverter(Field: TRttiField): IConverter;
var
  Attr: TCustomAttribute;
  ConverterName: string;
begin

  ConverterName := 'default';

  for Attr in Field.GetAttributes do
  begin

    if Attr is ConverterAttribute then
    begin
      ConverterName := ConverterAttribute(Attr).ClassName;
      break;
    end;

  end;

  if ConverterName.Equals('default') then
    Exit(TGenericConverter.Create);

  Result := TInterfacedObject(TGlue.GetInstance.Resolve(ConverterName))
    as IConverter;

end;

procedure TDataManager.InitializeViewModel;
begin
  if FInitialMethod <> nil then
    FInitialMethod.Invoke(FViewModel, []);
end;

procedure TDataManager.OnAfter(Instance: TObject; Method: TRttiMethod;
  const Args: TArray<TValue>; var Result: TValue);
var
  Attribute: NotifyChangeAttribute;
begin
  Attribute := TAttributeUtils.GetAttribute<NotifyChangeAttribute>(Method);

  if Assigned(Attribute) then
    Update(Attribute.PropertiesNames);
end;

procedure TDataManager.OnAfterAction(ActionName: string);
begin

end;

procedure TDataManager.OnBeforeAction(ActionName: string);
begin

end;

procedure TDataManager.ReleaseData;
var
  Command: ICommand;
begin

  for Command in FCommands.Values.ToArray do
    Command.Detach(Self);

end;

procedure TDataManager.Update(const PropertiesNames: TArray<string>);
var
  Value: string;
begin

  for Value in PropertiesNames do
    Update(Value);

end;

procedure TDataManager.Update(const PropertyName: string);
var
  Binder: IBinding;
  Binders: TList<IBinding>;
begin

  if PropertyName.Equals('*') then
  begin

    for Binders in FBinders.GetValues do
      for Binder in Binders do
        Binder.UpdateTarget;

    Exit;
  end;  

  if not FBinders.ContainsKey(PropertyName) then
    Exit;

  Binders := FBinders.GetItems(PropertyName);

  for Binder in Binders do
    Binder.UpdateTarget;
end;

end.
