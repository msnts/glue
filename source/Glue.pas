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
      FViews : TDictionary<String, TClass>;
      FViewModels : TDictionary<String, TClass>;
      FConverters : TDictionary<String, TClass>;
      FDependencyResolver : TDependencyResolver;
   private
      procedure ProcessDataBind(View : TObject);
      class procedure ReleaseInstance();
      function GetViewModelInstance(ClassName : String) : TObject;
   public
      class function GetInstance() : TGlue;
      constructor Create();
      destructor Destroy(); override;
      procedure SetDependencyResolver(Resolver : TDependencyResolver);
      procedure Run(ClassType : TComponentClass);
      function GetConverter(QualifiedClassName : String) : TClass;
      class procedure RegisterConverter(TypeClass : TClass);
      class procedure RegisterViewModel(ViewModel : TClass); overload;
      class procedure RegisterViewModel(QualifiedName : String; ClassType : TClass); overload;
      class procedure RegisterView(QualifiedName : String; ClassType : TClass);
   end;

implementation
uses Glue.Exceptions, System.SysUtils;

{ TGlue }

constructor TGlue.Create;
begin
   FViewModels := TDictionary<String, TClass>.Create;
   FViews := TDictionary<String, TClass>.Create;
   FConverters := TDictionary<String, TClass>.Create;
end;

destructor TGlue.Destroy;
begin
  FViewModels.Free;
  FViews.Free;
  FConverters.Free;
  inherited;
end;

function TGlue.GetConverter(QualifiedClassName: String): TClass;
begin

   if not FConverters.ContainsKey(QualifiedClassName) then
      raise EConverterNotFoundException.Create('Converter Not Found');

   Result := FConverters.Items[QualifiedClassName];

end;

class function TGlue.GetInstance: TGlue;
begin

   if not Assigned(Self.FInstance) then
      Self.FInstance := TGlue.Create;

   Result := Self.FInstance;
end;

function TGlue.GetViewModelInstance(ClassName: String): TObject;
var
   ClassType: TClass;
   c: TRttiContext;
  t: TRttiType;
  v: TValue;
begin

   if not FViewModels.ContainsKey(ClassName) then
      Exit(nil);

   ClassType := FViewModels.Items[ClassName];

   if Assigned(FDependencyResolver) then
      Result := FDependencyResolver(ClassType)
   else
   begin

      c:= TRttiContext.Create;

      try

         t:= c.GetType(ClassType);

         v:= t.GetMethod('Create').Invoke(t.AsInstance.MetaclassType,[]);

         Result := v.AsObject;

      finally
         c.Free;
      end;


   end;

end;

procedure TGlue.ProcessDataBind(View: TObject);
begin

end;

class procedure TGlue.RegisterConverter(TypeClass: TClass);
begin
   FInstance.FConverters.Add(TypeClass.QualifiedClassName, TypeClass);
end;

class procedure TGlue.RegisterView(QualifiedName: String; ClassType: TClass);
begin

end;

class procedure TGlue.RegisterViewModel(ViewModel: TClass);
begin
   RegisterViewModel(ViewModel.QualifiedClassName, ViewModel);
end;

class procedure TGlue.RegisterViewModel(QualifiedName: String; ClassType: TClass);
begin
   FInstance.FViewModels.Add(QualifiedName, ClassType);
end;

class procedure TGlue.ReleaseInstance;
begin
   if Assigned(Self.FInstance) then
    Self.FInstance.Free;
end;

procedure TGlue.Run(ClassType : TComponentClass);
var
   Form : TForm;
   ViewModel : TObject;
   DataMananger : IDataManager;
   Attribute : ViewModelAttribute;
begin

   Application.CreateForm(ClassType, Form);

 {  Attribute := TAttributeUtils.GetAttribute<ViewModelAttribute>(ClassType);

   if not Assigned(Attribute) then
      raise Exception.Create('View Model Not Found');   }

   ViewModel := GetViewModelInstance('UViewModelForm.TViewModelForm');

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
