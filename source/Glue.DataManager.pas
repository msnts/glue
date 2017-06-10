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
   Glue.Binding.Command;

type

   TDataManager = class(TInterfacedObject, IObserver)
   private
      FView : TComponent;
      FViewModel : INotifyPropertyChanging;
      FBinders : TDictionary<String, IBinding>;
      FCommands : TDictionary<String, ICommand>;
   private
      procedure DataBinding();
      procedure AddBind(Field: TRttiField; Attr: TBindBaseAttribute);
      procedure AddCommand(Field: TRttiField; Attr: CommandAttribute);
   public
      constructor Create(View : TComponent; ViewModel : INotifyPropertyChanging);
      destructor Destroy(); override;
      procedure Update(const PropertyName: string);
   end;

implementation
uses System.SysUtils;

{ TDataBinding }

procedure TDataManager.AddBind(Field: TRttiField; Attr: TBindBaseAttribute);
var
   Binding : IBinding;
begin

   Binding := TBinding.Create(Attr.Mode, FView.FindComponent(Field.Name), FViewModel,  Attr.BindContext);

   FBinders.Add(Attr.BindContext.AttributeVM, Binding);

end;

procedure TDataManager.AddCommand(Field: TRttiField; Attr: CommandAttribute);
begin

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
            Break;
         end;

         if Attr is CommandAttribute then
         begin
            AddCommand(Field, CommandAttribute(Attr));
            Break;
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
