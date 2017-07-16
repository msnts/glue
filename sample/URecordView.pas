unit URecordView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Glue, Glue.Attributes, Vcl.ComCtrls,
  Glue.View.Vcl;

type

  [ViewModel('URecordViewModel.TRecordViewModel')]
  TForm1 = class(TForm)
    [Load('target=Caption; source=LabelNome')]
    lbl1: TLabel;
  //  [Bind('target=Text; source=PrimeiroNome')]
    edtNome: TEdit;
   // [Bind('target=Text; source=SegundoNome')]
    edtNome2: TEdit;
    [Command('OnClick')]
    btn1: TButton;
   // [Bind('target=Text; source=Numero1')]
    Edit1: TEdit;
   // [Bind('target=Text; source=Numero2')]
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
   // [Load('target=Text; source=ResultadoSoma')]
    Edit3: TEdit;

   // [Save('target=Checked; source=EnableCheck1')]
   // [Load('target=Caption; source=LabelCheck1')]
    CheckBox1: TCheckBox;

    [Bind('target=Data; source=Items')]
    [Bind('target=SelectedItem; source=SelectedItem')]
    [Template('Format("%d", {Item}.Id) + " " + {Item}.Text')]
    ComboBox1: TComboBox;

    ListBox1: TListBox;
    RadioButton1: TRadioButton;
   // [Load('target=Caption; source=MsgNumChar')]
    Label4: TLabel;
    grp1: TGroupBox;
    RadioButton2: TRadioButton;
    DateTimePicker1: TDateTimePicker;

    [Bind('target=Date; source=TestDate')]
    MonthCalendar1: TMonthCalendar;
    RadioButton3: TRadioButton;

    [Load('target=Lines; source=Logs')]
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

initialization

TGlue.RegisterType(TForm1, 'FrmDetails');

end.
