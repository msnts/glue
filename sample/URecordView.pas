unit URecordView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Glue, Glue.Attributes, Vcl.ComCtrls,
  Glue.View.Vcl;

type

  [ViewModel('RecordViewModel')]
  TRecordView = class(TForm)
    [Load('Caption', 'FullName')]
    lbFirstName: TLabel;
    [Bind('edtFistName.Text', 'FistName')]
    edtFistName: TEdit;
    [Bind('edtLastName.Text', 'LastName')]
    edtLastName: TEdit;
    [Command('btn1.OnClick', 'OnClick')]
    btn1: TButton;
    Edit1: TEdit;
    [Save('CheckBox1.Checked', 'EnableCheck1')]
    [Load('CheckBox1.Caption', 'LabelCheck1')]
    CheckBox1: TCheckBox;
    [Load('cmbGender.Data', 'Items')]
    cmbGender: TComboBox;
    ListBox1: TListBox;
    RadioButton1: TRadioButton;
    grp1: TGroupBox;
    RadioButton2: TRadioButton;
    [Save('dtpDate.Date', 'TestDate')]
    dtpDate: TDateTimePicker;
    RadioButton3: TRadioButton;
    [Load('Memo1.Lines', 'Logs')]
    Memo1: TMemo;
    lbLastName: TLabel;
    lbGender: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    [Load('StatusBar1.Panels.Items[1].Text', 'FullName')]
    StatusBar1: TStatusBar;
    [Load('lbCount.Caption', 'MsgNumChar')]
    lbCount: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RecordView: TRecordView;

implementation

{$R *.dfm}

initialization

TGlue.RegisterType(TRecordView, 'FrmDetails');

end.
