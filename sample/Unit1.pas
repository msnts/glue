unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Glue.Attributes;

type

  [ViewModel('UViewModelForm.TViewModelForm')]
  TForm1 = class(TForm)
    [Load('target=Caption; source=LabelNome')]
    lbl1: TLabel;
    [Bind('target=Text; source=PrimeiroNome')]
    edtNome: TEdit;
    [Bind('target=Text; source=SegundoNome')]
    edtNome2: TEdit;
    [Command('OnClick')]
    btn1: TButton;
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
