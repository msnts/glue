program Project1;

uses
  Vcl.Forms,
  Glue.Converter in '..\source\converter\Glue.Converter.pas',
  Glue.Binding in '..\source\binding\Glue.Binding.pas',
  Glue.Binding.Impl.Binding in '..\source\binding\impl\Glue.Binding.Impl.Binding.pas',
  Glue.Binding.BindingContext in '..\source\binding\Glue.Binding.BindingContext.pas',
  Glue.Attributes in '..\source\Glue.Attributes.pas',
  Glue.BindableBase in '..\source\Glue.BindableBase.pas',
  Glue.DataManager in '..\source\Glue.DataManager.pas',
  Glue.NotifyPropertyChanging in '..\source\Glue.NotifyPropertyChanging.pas',
  Glue.Observer in '..\source\Glue.Observer.pas',
  Glue in '..\source\Glue.pas',
  Unit1 in 'Unit1.pas' {Form1},
  UViewModelForm in 'UViewModelForm.pas',
  Glue.Enum in '..\source\Glue.Enum.pas',
  Glue.ActionListener in '..\source\Glue.ActionListener.pas',
  Glue.Binding.Command in '..\source\binding\Glue.Binding.Command.pas',
  Glue.Converter.Impl.GenericConverter in '..\source\converter\impl\Glue.Converter.Impl.GenericConverter.pas',
  Glue.Exceptions in '..\source\Glue.Exceptions.pas',
  Glue.Binding.Impl.Command in '..\source\binding\impl\Glue.Binding.Impl.Command.pas',
  Glue.AttributeUtils in '..\source\Glue.AttributeUtils.pas',
  Glue.Executions in '..\source\Glue.Executions.pas',
  URecordManagerView in 'URecordManagerView.pas' {RecordManagerView},
  URecordManagerViewModel in 'URecordManagerViewModel.pas';

{$R *.res}

begin

  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  TGlue.GetInstance.Run(TRecordManagerView);
end.
