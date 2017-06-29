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
   Glue.NotifyPropertyChanging,
   Glue.BindableBase,
   Glue.DataManager,
   Glue.AttributeUtils;

type

   TDependencyResolver = reference to function (ClassType : TClass) : TInterfacedObject;

   TGlue = class
   private
      class var FInstance : TGlue;
   private
      FTypes : TDictionary<String, TClass>;
      FDependencyResolver : TDependencyResolver;
   private
      class procedure ReleaseInstance();
      function GetRegisteredType(const QualifiedClassName : String) : TClass;
   public
      class function GetInstance() : TGlue;
      constructor Create();
      destructor Destroy(); override;
      procedure SetDependencyResolver(Resolver : TDependencyResolver);
      procedure Run(ClassType : TComponentClass);
      function Resolve(const QualifiedClassName : String) : TObject;
      class procedure RegisterType(ClassType : TClass); overload;
      class procedure RegisterType(QualifiedName : String; ClassType : TClass); overload;
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
      raise Exception.Create('Type register not found');

   Result := FTypes.Items[QualifiedClassName];

end;

class procedure TGlue.RegisterType(QualifiedName: String; ClassType: TClass);
begin
   FInstance.FTypes.Add(QualifiedName, ClassType);
end;

class procedure TGlue.RegisterType(ClassType : TClass);
begin
   RegisterType(ClassType.QualifiedClassName, ClassType);
end;

class procedure TGlue.ReleaseInstance;
begin
   if Assigned(Self.FInstance) then
    Self.FInstance.Free;
end;

function TGlue.Resolve(const QualifiedClassName: String): TObject;
var
   ClsType : TClass;
   c: TRttiContext;
  t: TRttiType;
  v: TValue;
  Method : TRttiMethod;
  Parameters : TArray<TRttiParameter>;
begin

   ClsType := GetRegisteredType(QualifiedClassName);

   if Assigned(FDependencyResolver) then
      Result := FDependencyResolver(ClsType)
   else
   begin

      c:= TRttiContext.Create;

      try

         t:= c.GetType(ClsType);

         Method := t.GetMethod('Create');

         Parameters := Method.GetParameters;

         if Length(Parameters) = 1 then
            v:= Method.Invoke(t.AsInstance.MetaclassType,[nil])
         else
            v:= Method.Invoke(t.AsInstance.MetaclassType,[]);

         Result := v.AsObject;

      finally
         c.Free;
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

initialization

   TGlue.GetInstance;

finalization
   TGlue.ReleaseInstance;
end.
