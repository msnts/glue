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
   Glue.Binding.Factory;

type

   TDataManager = class(TInterfacedObject, IObserver)
   private
      FView : TComponent;
      FViewModel : INotifyPropertyChanging;
      FBinders : TDictionary<String, IBinding>;
   private
      procedure DataBinding();
      procedure AddBind(Field: TRttiField; Attr: BindAttribute);
      procedure AddLoad(Field: TRttiField; Attr: LoadAttribute);
      procedure AddSave(Field: TRttiField; Attr: SaveAttribute);
   public
      constructor Create(View : TComponent; ViewModel : INotifyPropertyChanging);
      destructor Destroy(); override;
      procedure Update(const PropertyName: string);
   end;

implementation

{ TDataBinding }

procedure TDataManager.AddBind(Field: TRttiField; Attr: BindAttribute);
var
   Binding : IBinding;
begin

   Binding := TBindingFactory.CreateBinding(Field.FieldType.Name, mbSaveLoad, Attr.BindContext);

   Binding.SetComponent(FView.FindComponent(Field.Name));

   Binding.SetViewModel(FViewModel);

   Binding.ProcessBinding();

   FBinders.Add(Attr.BindContext.AttributeVM, Binding);

end;

procedure TDataManager.AddLoad(Field: TRttiField; Attr: LoadAttribute);
var
   Binding : IBinding;
begin

   Binding := TBindingFactory.CreateBinding(Field.FieldType.Name, mbLoad, Attr.BindContext);

   FBinders.Add(Attr.BindContext.AttributeVM, Binding);

end;

procedure TDataManager.AddSave(Field: TRttiField; Attr: SaveAttribute);
var
   Binding : IBinding;
begin

   Binding := TBindingFactory.CreateBinding(Field.FieldType.Name, mbSave, Attr.BindContext);

   FBinders.Add(Attr.BindContext.AttributeVM, Binding);

end;

constructor TDataManager.Create(View: TComponent;
  ViewModel: INotifyPropertyChanging);
begin
   FView := View;
   FViewModel := ViewModel;

   FViewModel.Attach(Self);

   FBinders := TDictionary<String, IBinding>.Create;

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

         if Attr is BindAttribute then
         begin
            AddBind(Field, BindAttribute(Attr));
            Break;
         end;

         if Attr is LoadAttribute then
         begin
            AddLoad(Field, LoadAttribute(Attr));
            Break;
         end;

         if Attr is SaveAttribute then
         begin
            AddSave(Field, SaveAttribute(Attr));
            Break;
         end;

      end;

   end;

end;

destructor TDataManager.Destroy;
begin
  FBinders.Free;
  inherited;
end;

procedure TDataManager.Update(const PropertyName: string);
var
   Binder : IBinding;
begin

   if not FBinders.ContainsKey(PropertyName) then
      Exit;

   Binder := FBinders.Items[PropertyName];

   Binder.UpdateView;

end;

end.
