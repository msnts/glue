unit Glue.Binding.Impl.EditBinding;

interface
uses
   Vcl.StdCtrls,
   Glue.Binding.EditBinding,
   Glue.Binding.Impl.Binding;

type

   TEditBinding = class(TBinding, IEditBinding)
   private
      procedure OnChange(Sender: TObject);
   public
      procedure ProcessBinding(); override;
   end;

implementation

{ TEditBinding }

procedure TEditBinding.OnChange(Sender: TObject);
var
   ViewModel : TObject;
begin
  ViewModel := TObject(FViewModel);
end;

procedure TEditBinding.ProcessBinding;
var
   Edit : TEdit;
begin

   Edit := TEdit(FComponent);

   Edit.OnChange := OnChange;

end;

end.
