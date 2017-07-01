unit URecordManagerView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Glue, Glue.Attributes;

type
  [ViewModel('URecordManagerViewModel.TRecordManagerViewModel')]
  TRecordManagerView = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    [Command('OnAddClick')]
    BtnAdd: TButton;
    BtnEdit: TButton;
    BtnDelete: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RecordManagerView: TRecordManagerView;

implementation

{$R *.dfm}

initialization

TGlue.RegisterType(TRecordManagerView, 'FrmManager');

end.
