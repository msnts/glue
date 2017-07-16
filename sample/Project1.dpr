program Project1;

uses
  Vcl.Forms,
  Glue.Converter in '..\source\converter\Glue.Converter.pas',
  Glue.Binding in '..\source\binding\Glue.Binding.pas',
  Glue.Binding.Impl.Binding in '..\source\binding\impl\Glue.Binding.Impl.Binding.pas',
  Glue.Binding.BindingContext in '..\source\binding\Glue.Binding.BindingContext.pas',
  Glue.Attributes in '..\source\Glue.Attributes.pas',
  Glue.DataManager in '..\source\Glue.DataManager.pas',
  Glue.Observer in '..\source\Glue.Observer.pas',
  Glue in '..\source\Glue.pas',
  URecordView in 'URecordView.pas' {Form1},
  URecordViewModel in 'URecordViewModel.pas',
  Glue.ActionListener in '..\source\Glue.ActionListener.pas',
  Glue.Binding.Command in '..\source\binding\Glue.Binding.Command.pas',
  Glue.Converter.Impl.GenericConverter in '..\source\converter\impl\Glue.Converter.Impl.GenericConverter.pas',
  Glue.Exceptions in '..\source\Glue.Exceptions.pas',
  Glue.Binding.Impl.Command in '..\source\binding\impl\Glue.Binding.Impl.Command.pas',
  Glue.AttributeUtils in '..\source\Glue.AttributeUtils.pas',
  Glue.Executions in '..\source\Glue.Executions.pas',
  URecordManagerView in 'URecordManagerView.pas' {RecordManagerView},
  URecordManagerViewModel in 'URecordManagerViewModel.pas',
  Glue.View.DataTemplate in '..\source\view\Glue.View.DataTemplate.pas',
  Glue.View.Vcl in '..\source\view\Glue.View.Vcl.pas',
  Glue.ViewModel.ListDataListener in '..\source\viewmodel\Glue.ViewModel.ListDataListener.pas',
  Glue.ViewModel.ListModel in '..\source\viewmodel\Glue.ViewModel.ListModel.pas',
  Glue.ViewModel.ListModelList in '..\source\viewmodel\Glue.ViewModel.ListModelList.pas',
  Glue.ViewModel.Impl.ListModelList in '..\source\viewmodel\impl\Glue.ViewModel.Impl.ListModelList.pas';

{$R *.res}

begin

  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  TGlue.GetInstance.Run(TRecordManagerView);
end.
