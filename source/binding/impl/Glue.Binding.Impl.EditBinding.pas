unit Glue.Binding.Impl.EditBinding;

interface
uses
   Rtti,
   Vcl.StdCtrls,
   Glue.Binding.EditBinding,
   Glue.Binding.Impl.Binding;

type

   TEditBinding = class(TBinding, IEditBinding)
   private
      procedure OnChange(Sender: TObject);
   protected
      procedure DoUpdateView(); override;
   public
      procedure ProcessBinding(); override;
   end;

implementation

{ TEditBinding }

procedure TEditBinding.DoUpdateView;
var
   Value : String;
begin

   Value := FPropertyVM.GetValue(FViewModel as TObject).AsString;

   FPropertyUI.SetValue(FComponent, Value);

end;

procedure TEditBinding.OnChange(Sender: TObject);
var
   Value : String;
begin

   Value := FPropertyUI.GetValue(TEdit(FComponent)).AsString;

   FPropertyVM.SetValue(FViewModel as TObject, Value);

end;

procedure TEditBinding.ProcessBinding;
var
   Edit: TEdit;
   objType: TRttiType;
   Prop : TRttiProperty;
begin

   Edit := TEdit(FComponent);

   objType := FRTTIContext.GetType(TObject(FViewModel).ClassType);

   FPropertyVM := objType.GetProperty(FBindContext.AttributeVM);

   objType := FRTTIContext.GetType(FComponent.ClassType);

   FPropertyUI := objType.GetProperty(FBindContext.AttributeUI);

   Edit.OnChange := OnChange;

end;

end.
