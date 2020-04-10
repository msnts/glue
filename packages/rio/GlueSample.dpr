program GlueSample;

uses
  Vcl.Forms,
  Glue,
  URecordManagerView in '..\..\sample\URecordManagerView.pas' {RecordManagerView},
  URecordManagerViewModel in '..\..\sample\URecordManagerViewModel.pas',
  URecordView in '..\..\sample\URecordView.pas' {Form1},
  URecordViewModel in '..\..\sample\URecordViewModel.pas';
{$R *.res}

begin

  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  TGlue.GetInstance.Run(TRecordManagerView);
end.
