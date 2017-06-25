unit URecordManagerViewModel;

interface
uses
   Glue,
   Glue.Attributes,
   Glue.Executions;

type

   TRecordManagerViewModel = class
   public
      procedure OnAddClick(Sender : TObject);
      procedure OnEditClick(Sender : TObject);
      procedure OnDeleteClick(Sender : TObject);

   end;

implementation

{ TRecordManagerViewModel }

procedure TRecordManagerViewModel.OnAddClick(Sender: TObject);
begin

   TExecutions.ShowWindows('RecordManagerView.TRecordManagerView');

end;

procedure TRecordManagerViewModel.OnDeleteClick(Sender: TObject);
begin

end;

procedure TRecordManagerViewModel.OnEditClick(Sender: TObject);
begin

end;

initialization
TGlue.RegisterViewModel(TRecordManagerViewModel);

end.
