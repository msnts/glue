unit Glue.Binding.Impl.LabelBinding;

interface
uses
   Glue.Binding.LabelBinding,
   Glue.Binding.Impl.Binding;

type

   TLabelBinding = class(TBinding, ILabelBinding)
   public
      procedure ProcessBinding(); override;
   end;

implementation

{ TLabelBinding }

procedure TLabelBinding.ProcessBinding;
begin
  inherited;

end;

end.
