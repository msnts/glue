unit Glue.Binding.Factory;

interface
uses
   Vcl.StdCtrls,
   System.SysUtils,
   System.Classes,
   Glue.Binding,
   Glue.NotifyPropertyChanging,
   Glue.Binding.BindingContext,
   Glue.Binding.Impl.EditBinding,
   Glue.Binding.Impl.CheckBoxBinding,
   Glue.Binding.Impl.LabelBinding;

type

   TBindingFactory = class
   public
      class function CreateBinding(ClassName : String; Mode : TModeBinding; Context : TBindContext) : IBinding;
   end;

implementation

{ TBindingFactory }

class function TBindingFactory.CreateBinding(ClassName: String; Mode : TModeBinding; Context : TBindContext): IBinding;
begin

   if 'TLabel'.Equals(ClassName) then
      Exit(TLabelBinding.Create(mbLoad, Context));

   if 'TEdit'.Equals(ClassName) then
      Exit(TEditBinding.Create(Mode, Context));

   if 'TCheckBox'.Equals(ClassName) then
      Exit(TCheckBoxBinding.Create(Mode, Context));

end;

end.
