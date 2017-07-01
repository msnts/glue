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

unit Glue;

interface
uses
   System.Rtti, System.TypInfo, Vcl.Forms, System.Classes,
   Generics.Collections,
   Glue.Attributes,
   Glue.DataManager,
   Glue.AttributeUtils;

type

   TDependencyResolver = reference to function (ClassType : TClass) : TInterfacedObject;

   TEventPublisherResolver = reference to procedure(Event : TObject);

   TGlue = class
   private
      class var FInstance : TGlue;
   private
      FTypes : TDictionary<String, TClass>;
      FDependencyResolver : TDependencyResolver;
      FEventPublisherResolver : TEventPublisherResolver;
   private
      class procedure ReleaseInstance();
      function GetRegisteredType(const QualifiedClassName : String) : TClass;
   public
      class function GetInstance() : TGlue;
      constructor Create();
      destructor Destroy(); override;
      procedure SetDependencyResolver(Resolver : TDependencyResolver);
      procedure SetEventPublisherResolve(Resolver : TEventPublisherResolver);
      procedure Run(ClassType : TComponentClass);
      function Resolve(const QualifiedClassName : String) : TObject;
      procedure PostEvent(Event : TObject);
      function HasDependencyResolver() : Boolean;
      class procedure RegisterType(ClassType : TClass); overload;
      class procedure RegisterType(ClassType : TClass; const Alias : String); overload;
   end;

implementation
uses Glue.Exceptions, System.SysUtils;

{ TGlue }

constructor TGlue.Create;
begin

   FTypes := TDictionary<String, TClass>.Create;

end;

destructor TGlue.Destroy;
begin
  FTypes.Free;
  inherited;
end;

class function TGlue.GetInstance: TGlue;
begin

   if not Assigned(Self.FInstance) then
      Self.FInstance := TGlue.Create;

   Result := Self.FInstance;
end;


function TGlue.GetRegisteredType(const QualifiedClassName: String): TClass;
begin

   if not FTypes.ContainsKey(QualifiedClassName) then
      raise EInvalidTypeRegisterException.Create('Type register not found');

   Result := FTypes.Items[QualifiedClassName];

end;

function TGlue.HasDependencyResolver: Boolean;
begin
   Result := Assigned(FDependencyResolver);
end;

procedure TGlue.PostEvent(Event: TObject);
begin

   if Assigned(FEventPublisherResolver) then
      FEventPublisherResolver(Event);

end;

class procedure TGlue.RegisterType(ClassType : TClass);
begin
   RegisterType(ClassType, 'default');
end;

class procedure TGlue.RegisterType(ClassType: TClass; const Alias: String);
var
   QualifiedClassName : String;
   LocalAlias : String;
begin

   QualifiedClassName := ClassType.QualifiedClassName;

   if not FInstance.FTypes.ContainsKey(QualifiedClassName) then
      FInstance.FTypes.Add(QualifiedClassName, ClassType);

   LocalAlias := Alias.Trim;

   if LocalAlias.Equals('default') then
      Exit;

   if LocalAlias.IsEmpty then
      raise EInvalidTypeRegisterException.Create('Invalid Type Register: Alias null or Empty');

   if FInstance.FTypes.ContainsKey(LocalAlias) then
   begin
      if not QualifiedClassName.Equals(FInstance.FTypes.Items[LocalAlias].QualifiedClassName) then
         raise EInvalidTypeRegisterException.Create('Invalid Type Register: Alias ' + LocalAlias.QuotedString + ' already linked to another type');

      Exit;
   end;

   FInstance.FTypes.Add(LocalAlias, ClassType);

end;

class procedure TGlue.ReleaseInstance;
begin
   if Assigned(Self.FInstance) then
    Self.FInstance.Free;
end;

function TGlue.Resolve(const QualifiedClassName: String): TObject;
var
   ClsType: TClass;
   Context: TRttiContext;
   RttiType: TRttiType;
   Value: TValue;
   Method: TRttiMethod;
begin

   ClsType := GetRegisteredType(QualifiedClassName);

   if Assigned(FDependencyResolver) then
      Result := FDependencyResolver(ClsType)
   else
   begin

      Context := TRttiContext.Create;

      try

         RttiType := Context.GetType(ClsType);

         Method := RttiType.GetMethod('Create');

         if ClsType.InheritsFrom(TForm) then
            Value := Method.Invoke(RttiType.AsInstance.MetaclassType, [Application])
         else
            Value := Method.Invoke(RttiType.AsInstance.MetaclassType, []);

         Result := Value.AsObject;

      finally
         Context.Free;
      end;

   end;

end;


procedure TGlue.Run(ClassType : TComponentClass);
var
   Form : TForm;
   ViewModel : TObject;
   DataMananger : IDataManager;
   Attribute : ViewModelAttribute;
begin

   Application.CreateForm(ClassType, Form);

   Attribute := TAttributeUtils.GetAttribute<ViewModelAttribute>(ClassType);

   if not Assigned(Attribute) then
      raise Exception.Create('View Model Not Found');

   ViewModel := Resolve('URecordManagerViewModel.TRecordManagerViewModel');

   try

      DataMananger := TDataManager.Create(Form, ViewModel);

      Application.Run;
   finally
      DataMananger.ReleaseData;

      ViewModel.Free;
   end;

end;

procedure TGlue.SetDependencyResolver(Resolver: TDependencyResolver);
begin
   FDependencyResolver := Resolver;
end;

procedure TGlue.SetEventPublisherResolve(Resolver: TEventPublisherResolver);
begin
   FEventPublisherResolver := Resolver;
end;

initialization

   TGlue.GetInstance;

finalization
   TGlue.ReleaseInstance;
end.
