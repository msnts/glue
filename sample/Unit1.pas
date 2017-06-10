unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Glue.Attributes;

type

  [ViewModel('UViewModelForm.TViewModelForm')]
  TForm1 = class(TForm)
    //[Load('target=Caption; source=LabelNome')]
    lbl1: TLabel;
    [Bind('target=Text; source=PrimeiroNome')]
    edtNome: TEdit;
   // [Bind('target=Text; source=SegundoNome')]
    edtNome2: TEdit;
   // [Command('OnClick')]
    btn1: TButton;
   // [Bind('target=Text; source=Numero1')]
    Edit1: TEdit;
   // [Bind('target=Text; source=Numero2')]
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
   // [Bind('target=Text; source=ResultadoSoma')]
    Edit3: TEdit;

   // [Bind('target=Checked; source=EnableCheck1')]
   // [Bind('target=Caption; source=LabelCheck1')]
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    ListBox1: TListBox;
    RadioButton1: TRadioButton;
    [Load('target=Caption; source=MsgNumChar')]
    Label4: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
