unit UViewModelForm;

interface
uses
   Glue,
   Glue.Attributes,
   System.Classes;

type

   TViewModelForm = class
   private
      FLabelNome : String;
      FPrimeiroNome : String;
      FSegundoNome : String;
      FNumero1 : Integer;
      FNumero2 : Double;
      FLabelCheck1 : String;
      FTestDate : TDate;
      FLogs : TStringList;
   private
      function GetLabelNome() : String;
      procedure SetLabelNome(Texto : String);
      function GetPrimeiroNome() : String;
      procedure SetPrimeiroNome(Nome : String);
      function GetSegundoNome() : String;
      procedure SetSegundoNome(Nome : String);
      function GetNumero1() : Integer;
      procedure SetNumero1(Num : Integer);
      function GetNumero2() : Double;
      procedure SetNumero2(Num : Double);
      function GetSoma : Double;
      function GetEnableEdit1() : Boolean;
      procedure SetEnableEdit1(Enable : Boolean);
      function GetMsgNumChar() : String;
      function GetTestDate() : TDate;
   public
      procedure OnClick(Sender : TObject; V : Integer);
      procedure SetTestDate(Date : TDate); virtual;
   public
      constructor Create; virtual;
      destructor Destroy; override;

      property LabelNome : String read GetLabelNome write SetLabelNome;
      property PrimeiroNome : String read GetPrimeiroNome write SetPrimeiroNome;
      property SegundoNome : String Read GetSegundoNome write SetSegundoNome;
      property Numero1 : Integer read GetNumero1 write SetNumero1;
      property Numero2 : Double read GetNumero2 write SetNumero2;
      property ResultadoSoma : Double read GetSoma;
      property EnableCheck1 : Boolean read GetEnableEdit1 write SetEnableEdit1;
      property LabelCheck1 : String read FLabelCheck1;
      property MsgNumChar : String read GetMsgNumChar;
      property TestDate : TDate read GetTestDate write SetTestDate;
      property Logs : TStringList read FLogs;
   end;


implementation
uses System.sysutils;

{ TViewModelForm }

constructor TViewModelForm.Create;
begin
   FLogs := TStringList.Create;
   FLogs.Add('Start Logs');
   FLabelNome := 'Label Nome Default';
end;

destructor TViewModelForm.Destroy;
begin
  FLogs.Free;
  inherited;
end;

function TViewModelForm.GetEnableEdit1: Boolean;
begin
   Result := True;
end;

function TViewModelForm.GetLabelNome: String;
begin
   Result := FLabelNome;
end;

function TViewModelForm.GetMsgNumChar: String;
begin
   Result := 'Count: ' + String.parse(FPrimeiroNome.Length);
end;

function TViewModelForm.GetNumero1: Integer;
begin
   Result := FNumero1;
end;

function TViewModelForm.GetNumero2: Double;
begin
   Result := FNumero2;
end;

function TViewModelForm.GetPrimeiroNome: String;
begin
   Result := FPrimeiroNome;
end;

function TViewModelForm.GetSegundoNome: String;
begin
   Result := FSegundoNome;
end;

function TViewModelForm.GetSoma: Double;
begin
   Result := FNumero1 + FNumero2;
end;

function TViewModelForm.GetTestDate: TDate;
begin
   Result := FTestDate;
end;

[NotifyChange('PrimeiroNome')]
procedure TViewModelForm.OnClick(Sender : TObject; V : Integer);
begin

   FPrimeiroNome := 'Onclick ' + Sender.ClassName;

end;

[NotifyChange('LabelCheck1')]
procedure TViewModelForm.SetEnableEdit1(Enable: Boolean);
begin

   if Enable then
      FLabelCheck1 := 'Enable On'
   else
      FLabelCheck1 := 'Enable Off';

end;

procedure TViewModelForm.SetLabelNome(Texto: String);
begin

end;

procedure TViewModelForm.SetNumero1(Num: Integer);
begin
   FNumero1 := Num;
end;

[NotifyChange('ResultadoSoma')]
procedure TViewModelForm.SetNumero2(Num: Double);
begin
   FNumero2 := Num;
end;

[NotifyChange('SegundoNome, MsgNumChar')]
procedure TViewModelForm.SetPrimeiroNome(Nome: String);
begin
   FPrimeiroNome := Nome;
   FSegundoNome := Nome;
end;

procedure TViewModelForm.SetSegundoNome(Nome: String);
begin
   FSegundoNome := Nome;
end;

[NotifyChange('Logs')]
procedure TViewModelForm.SetTestDate(Date: TDate);
begin

   FTestDate := Date;

   FLogs.Add('TestDate: ' + FormatDateTime('dd/mm/yyyy', Date));

end;

initialization
TGlue.RegisterViewModel(TViewModelForm);

end.
