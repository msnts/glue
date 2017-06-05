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
   private
      function GetLabelNome() : String;
      procedure SetLabelNome(Texto : String);
      function GetPrimeiroNome() : String;
      procedure SetPrimeiroNome(Nome : String);
      function GetSegundoNome() : String;
      procedure SetSegundoNome(Nome : String);
   public
      procedure OnClick();
   public
      property LabelNome : String read GetLabelNome write SetLabelNome;
      property PrimeiroNome : String read GetPrimeiroNome write SetPrimeiroNome;
      property SegundoNome : String Read GetSegundoNome write SetSegundoNome;
   end;


implementation

{ TViewModelForm }

function TViewModelForm.GetLabelNome: String;
begin

end;

function TViewModelForm.GetPrimeiroNome: String;
begin
   Result := FPrimeiroNome;
end;

function TViewModelForm.GetSegundoNome: String;
begin
   Result := FSegundoNome;
end;

procedure TViewModelForm.OnClick;
begin

end;

procedure TViewModelForm.SetLabelNome(Texto: String);
begin

end;

procedure TViewModelForm.SetPrimeiroNome(Nome: String);
begin
   FSegundoNome := Nome;

   Notify('SegundoNome');
end;

procedure TViewModelForm.SetSegundoNome(Nome: String);
begin
   FSegundoNome := Nome;
end;

end.
