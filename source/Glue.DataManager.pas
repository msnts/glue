unit Glue.DataManager;

interface
uses
   Rtti,
   System.Classes,
   Generics.Collections,
   Glue.Observer,
   Glue.NotifyPropertyChanging,
   Glue.Attributes,
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

   TDataManager = class(TInterfacedObject, IDataManager, IObserver)
   private
      FView : TComponent;
      FViewModel : INotifyPropertyChanging;
      FBinders : TDictionary<String, IBinding>;
      FCommands : TDictionary<String, ICommand>;
   private
      procedure DataBinding();
      procedure AddBind(Field: TRttiField; Attr: TBindBaseAttribute);
      procedure AddCommand(Field: TRttiField; Attr: CommandAttribute);
      function GetConverter(Field: TRttiField) : IConverter;
   public
      constructor Create(View : TComponent; ViewModel : INotifyPropertyChanging);
      destructor Destroy; override;
      procedure Update(const PropertyName: string);
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

constructor TDataManager.Create(View: TComponent;
  ViewModel: INotifyPropertyChanging);
begin

   FView := View;

   FViewModel := ViewModel;

   FViewModel.Attach(Self);

   FBinders := TDictionary<String, IBinding>.Create;

   FCommands := TDictionary<String, ICommand>.Create;

   DataBinding;

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

      end;

   end;

end;

destructor TDataManager.Destroy;
begin

   FBinders.Free;

   FCommands.Free;

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

   Result := TInterfacedObject(TGlue.GetInstance.GetConverter(ConverterName)).Create as IConverter;

end;

procedure TDataManager.ReleaseData;
begin
   FViewModel.Detach(Self);
end;

procedure TDataManager.Update(const PropertyName: string);
var
   Binder : IBinding;
begin

   if PropertyName.Equals('*') then
   begin

      for Binder in FBinders.Values.ToArray do
         Binder.UpdateView;

      Exit;
   end;

   if not FBinders.ContainsKey(PropertyName) then
      Exit;

   Binder := FBinders.Items[PropertyName];

   Binder.UpdateView;

end;

end.
