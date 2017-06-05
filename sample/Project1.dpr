program Project1;

uses
  Vcl.Forms,
  Glue.Converter in '..\source\converter\Glue.Converter.pas',
  Glue.Binding in '..\source\binding\Glue.Binding.pas',
  Glue.Binding.Factory in '..\source\binding\Glue.Binding.Factory.pas',
  Glue.Binding.Impl.Binding in '..\source\binding\impl\Glue.Binding.Impl.Binding.pas',
  Glue.Binding.EditBinding in '..\source\binding\Glue.Binding.EditBinding.pas',
  Glue.Binding.Impl.EditBinding in '..\source\binding\impl\Glue.Binding.Impl.EditBinding.pas',
  Glue.Binding.CheckBoxBinding in '..\source\binding\Glue.Binding.CheckBoxBinding.pas',
  Glue.Binding.Impl.CheckBoxBinding in '..\source\binding\impl\Glue.Binding.Impl.CheckBoxBinding.pas',
  Glue.Binding.LabelBinding in '..\source\binding\Glue.Binding.LabelBinding.pas',
  Glue.Binding.Impl.LabelBinding in '..\source\binding\impl\Glue.Binding.Impl.LabelBinding.pas',
  Glue.Binding.BindingContext in '..\source\binding\Glue.Binding.BindingContext.pas',
  Glue.Attributes in '..\source\Glue.Attributes.pas',
  Glue.BindableBase in '..\source\Glue.BindableBase.pas',
  Glue.DataManager in '..\source\Glue.DataManager.pas',
  Glue.NotifyPropertyChanging in '..\source\Glue.NotifyPropertyChanging.pas',
  Glue.Observer in '..\source\Glue.Observer.pas',
  Glue in '..\source\Glue.pas',
  Unit1 in 'Unit1.pas' {Form1},
  UViewModelForm in 'UViewModelForm.pas';

{$R *.res}

begin

  TGlue.GetInstance.Initialize;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  TGlue.GetInstance.Run(TForm1);
end.
