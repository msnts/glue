unit Glue.Binding.Factory;

interface
uses
   Vcl.StdCtrls,
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
      class function CreateBinding(ClassType : TClass; Mode : TModeBinding; Context : TBindContext) : IBinding;
   end;

implementation

{ TBindingFactory }

class function TBindingFactory.CreateBinding(ClassType: TClass; Mode : TModeBinding; Context : TBindContext): IBinding;
begin

   if ClassType = TLabel then
      Exit(TLabelBinding.Create(mbLoad, Context));

   if ClassType = TEdit then
      Exit(TEditBinding.Create(Mode, Context));

   if ClassType = TCheckBox then
      Exit(TCheckBoxBinding.Create(Mode, Context));

end;

end.
