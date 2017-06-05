unit Glue.Binding.Impl.Binding;

interface
uses
   System.Classes,
   Vcl.StdCtrls,
   Rtti,
   Glue.Binding,
   Generics.Collections,
   Glue.NotifyPropertyChanging,
   Glue.Binding.BindingContext,
   Glue.BindableBase;

type

   TBinding = class(TInterfacedObject, IBinding)
   protected
      FComponent : TComponent;
      FViewModel : INotifyPropertyChanging;
      FListenersBefore : TList<IBinding>;
      FListenersAfter : TList<IBinding>;
      FMode : TModeBinding;
      FBindContext : TBindContext;
      FRTTIContext : TRttiContext;
      FPropertyVM : TRttiProperty;
      FPropertyUI : TRttiProperty;
      FComponentType : TRttiType;
      FViewModelType : TRttiType;
   protected
      procedure DoUpdateView(); virtual; abstract;
   public
      constructor Create(Mode : TModeBinding; Context : TBindContext);
      destructor Destroy(); override;
      procedure UpdateView();
      procedure AddListenerBefore(Listener : IBinding);
      procedure AddListenerAfter(Listener : IBinding);
      procedure ProcessBinding(); virtual; abstract;
      procedure SetComponent(Component : TComponent);
      procedure SetViewModel(ViewModel : INotifyPropertyChanging);
   end;

implementation

{ TBinding }

procedure TBinding.AddListenerAfter(Listener: IBinding);
begin
   FListenersAfter.Add(Listener);
end;

procedure TBinding.AddListenerBefore(Listener: IBinding);
begin
   FListenersBefore.Add(Listener);
end;

constructor TBinding.Create(Mode : TModeBinding; Context : TBindContext);
begin

   FMode := Mode;

   FBindContext := Context;

   FListenersBefore := TList<IBinding>.Create;
   FListenersAfter := TList<IBinding>.Create;

   FRTTIContext := TRttiContext.Create;

end;

destructor TBinding.Destroy;
begin
  FListenersBefore.Free;
  FListenersAfter.Free;
  inherited;
end;

procedure TBinding.SetComponent(Component: TComponent);
begin
   FComponent := Component;
end;

procedure TBinding.SetViewModel(ViewModel: INotifyPropertyChanging);
begin
   FViewModel := ViewModel;
end;

procedure TBinding.UpdateView;
var
   Binding : IBinding;
begin

   for Binding in FListenersBefore do
      Binding.UpdateView;

   DoUpdateView;

   for Binding in FListenersAfter do
      Binding.UpdateView;

end;

end.
