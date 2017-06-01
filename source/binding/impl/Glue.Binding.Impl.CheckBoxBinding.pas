unit Glue.Binding.Impl.CheckBoxBinding;

interface
uses
   Vcl.StdCtrls,
   Glue.Binding.CheckBoxBinding,
   Glue.Binding.Impl.Binding;

type

   TCheckBoxBinding = class(TBinding, ICheckBoxBinding)
   private
      procedure OnCheck(Sender: TObject);
   public
      procedure ProcessBinding(); override;
   end;

implementation

{ TCheckBoxBinding }

procedure TCheckBoxBinding.OnCheck(Sender: TObject);
begin

end;

procedure TCheckBoxBinding.ProcessBinding;
var
   CheckBox : TCheckBox;
begin

   CheckBox := TCheckBox(FComponent);

   CheckBox.OnClick := OnCheck;

end;

end.
