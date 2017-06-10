unit UViewModelForm;

interface
uses
   Glue.BindableBase;

type

   TViewModelForm = class(TBindableBase)
   private
      FLabelNome : String;
      FPrimeiroNome : String;
      FSegundoNome : String;
      FNumero1 : Integer;
      FNumero2 : Double;
      FLabelCheck1 : String;
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
   public
      procedure OnClick();
   public
      property LabelNome : String read GetLabelNome write SetLabelNome;
      property PrimeiroNome : String read GetPrimeiroNome write SetPrimeiroNome;
      property SegundoNome : String Read GetSegundoNome write SetSegundoNome;
      property Numero1 : Integer read GetNumero1 write SetNumero1;
      property Numero2 : Double read GetNumero2 write SetNumero2;
      property ResultadoSoma : Double read GetSoma;
      property EnableCheck1 : Boolean read GetEnableEdit1 write SetEnableEdit1;
      property LabelCheck1 : String read FLabelCheck1;
      property MsgNumChar : String read GetMsgNumChar;
   end;


implementation
uses System.sysutils;

{ TViewModelForm }

function TViewModelForm.GetEnableEdit1: Boolean;
begin
   Result := True;
end;

function TViewModelForm.GetLabelNome: String;
begin
   Result := FLabelCheck1;
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

procedure TViewModelForm.OnClick;
begin

end;

procedure TViewModelForm.SetEnableEdit1(Enable: Boolean);
begin

   if Enable then
      FLabelCheck1 := 'Enable On'
   else
      FLabelCheck1 := 'Enable Off';

   Notify('LabelCheck1');
end;

procedure TViewModelForm.SetLabelNome(Texto: String);
begin

end;

procedure TViewModelForm.SetNumero1(Num: Integer);
begin
   FNumero1 := Num;
end;

procedure TViewModelForm.SetNumero2(Num: Double);
begin
   FNumero2 := Num;
   Notify('ResultadoSoma');
end;

procedure TViewModelForm.SetPrimeiroNome(Nome: String);
begin
   FPrimeiroNome := Nome;
   FSegundoNome := Nome;

   Notify(['SegundoNome', 'MsgNumChar']);
end;

procedure TViewModelForm.SetSegundoNome(Nome: String);
begin
   FSegundoNome := Nome;
end;

end.
