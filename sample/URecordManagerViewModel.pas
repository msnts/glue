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

   TExecutions.ShowWindow('FrmDetails');

end;

procedure TRecordManagerViewModel.OnDeleteClick(Sender: TObject);
begin

end;

procedure TRecordManagerViewModel.OnEditClick(Sender: TObject);
begin
   TExecutions.ShowWindow('FrmDetails');
end;

initialization
TGlue.RegisterType(TRecordManagerViewModel);

end.
