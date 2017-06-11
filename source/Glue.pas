unit Glue;

interface
uses
   System.Rtti, System.TypInfo, Vcl.Forms, System.Classes,
   Generics.Collections,
   Glue.Attributes,
   Glue.NotifyPropertyChanging,
   Glue.BindableBase,
   Glue.DataManager,
   UViewModelForm;

type

   TGlue = class
   private
      class var FInstance : TGlue;
      class var FConverters : TDictionary<String, TClass>;
   private
      FViewModels : TDictionary<String, String>;
      FContext : TRttiContext;
      FCurrentType : TRttiType;
   private
      procedure ProcessAutoRegister();
      procedure ProcessDataBind(View : TObject);
      procedure RegisterViewModel(Attribute : ViewModelAttribute);
      class procedure ReleaseInstance();
      function GetViewModelInstance(ViewName : String) : INotifyPropertyChanging;
   public
      class function GetInstance() : TGlue;
      constructor Create();
      destructor Destroy(); override;
      procedure Initialize();
      procedure Run(ClassName : TComponentClass);
      function GetConverter(QualifiedClassName : String) : TClass;
      class procedure RegisterConverter(TypeClass : TClass);
   end;

implementation
uses Glue.Exceptions;

{ TGlue }

constructor TGlue.Create;
begin
   FViewModels := TDictionary<String, String>.Create;
end;

destructor TGlue.Destroy;
begin
  FViewModels.Free;
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

function TGlue.GetViewModelInstance(ViewName: String): INotifyPropertyChanging;
var
   ViewModelName : String;
   Context : TRttiContext;
   InstanceType : TRttiInstanceType;
begin

   if not FViewModels.ContainsKey(ViewName) then
      Exit(nil);

   ViewModelName := FViewModels.Items[ViewName];

   Context := TRttiContext.Create();

   try

     // InstanceType := (Context.FindType(ViewModelName) as TRttiInstanceType);

    //  Result := InstanceType.MetaclassType.Create;

   Result := TViewModelForm.Create;

   finally
      Context.Free;
   end;
end;

procedure TGlue.Initialize;
begin

   FInstance.ProcessAutoRegister;

end;

procedure TGlue.ProcessAutoRegister;
var
   Attribute: TCustomAttribute;
   typ : TRttiType;
begin

   FContext := TRttiContext.Create();

   try
      for typ in FContext.GetTypes() do
      begin

         FCurrentType := typ;

         if FCurrentType.TypeKind <> tkClass then
            continue;

         for Attribute in FCurrentType.GetAttributes() do
         begin

            if Attribute is ViewModelAttribute then
            begin
               RegisterViewModel(ViewModelAttribute(Attribute));
               break;
            end;

         end;

      end;
   finally
      FContext.Free;
   end;

end;

procedure TGlue.ProcessDataBind(View: TObject);
var
   DataManager : IObserver;

begin

end;

class procedure TGlue.RegisterConverter(TypeClass: TClass);
begin
   FConverters.Add(TypeClass.QualifiedClassName, TypeClass);
end;

procedure TGlue.RegisterViewModel(Attribute: ViewModelAttribute);
var
   ClassType : TClass;
   InstanceType : TRttiInstanceType;
begin

   InstanceType := (FContext.FindType('UViewModelForm.TViewModelForm') as TRttiInstanceType);



   FViewModels.Add(FCurrentType.QualifiedName, Attribute.ClassName);
end;

class procedure TGlue.ReleaseInstance;
begin
   if Assigned(Self.FInstance) then
    Self.FInstance.Free;

    FConverters.Free;

end;

procedure TGlue.Run(ClassName : TComponentClass);
var
   Form : TForm;
   ViewModel : INotifyPropertyChanging;
   DataMananger : IDataManager;
begin

   Application.CreateForm(ClassName, Form);

   ViewModel := GetViewModelInstance(Form.QualifiedClassName);

   DataMananger := TDataManager.Create(Form, ViewModel);

   try
      Application.Run;
   finally
      DataMananger.ReleaseData;
   end;

end;

initialization
finalization
   TGlue.ReleaseInstance;
end.
