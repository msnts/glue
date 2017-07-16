unit URecordViewModel;

interface
uses
   System.Generics.Collections,
   Glue,
   Glue.Attributes,
   System.Classes,
   Glue.ViewModel.ListModel,
   Glue.ViewModel.ListModelList,
   Glue.ViewModel.Impl.ListModelList;

type

   TItem = class
   private
      FId : Integer;
      FText : String;
   public
      constructor Create(const AId : Integer; const AText : String);
      property Id : Integer read FId;
      property Text : String read FText;
   end;

   TRecordViewModel = class
   private
      FLabelNome : String;
      FPrimeiroNome : String;
      FSegundoNome : String;
      FNumero1 : Integer;
      FNumero2 : Double;
      FLabelCheck1 : String;
      FTestDate : TDate;
      FLogs : TStringList;
      FListObject : IListModelList<TItem>;
      FSelectedItem : TItem;
   public
      constructor Create; virtual;
      destructor Destroy; override;
      function GetLabelNome() : String;
      procedure SetLabelNome(Texto : String); virtual;
      function GetPrimeiroNome() : String;

      [NotifyChange('SegundoNome, MsgNumChar')]
      procedure SetPrimeiroNome(Nome : String); virtual;
      function GetSegundoNome() : String;
      procedure SetSegundoNome(Nome : String); virtual;
      function GetNumero1() : Integer;
      procedure SetNumero1(Num : Integer); virtual;
      function GetNumero2() : Double;

      [NotifyChange('ResultadoSoma')]
      procedure SetNumero2(Num : Double); virtual;
      function GetSoma : Double;
      function GetEnableEdit1() : Boolean;

      [NotifyChange('LabelCheck1')]
      procedure SetEnableEdit1(Enable : Boolean); virtual;
      function GetMsgNumChar() : String;
      function GetTestDate() : TDate;

      [NotifyChange('PrimeiroNome')]
      procedure OnClick(Sender : TObject; V : Integer);

      [NotifyChange('Logs')]
      procedure SetTestDate(Date : TDate); virtual;

      function GetItems : IListModel;
      procedure SetItems(const Items : IListModel);

      function GetSelectedItem() : TItem;

      [NotifyChange('Logs')]
      procedure SetSelectedItem(const Item : TItem);

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
      property Items : IListModel read GetItems write SetItems;
      property SelectedItem : TItem read GetSelectedItem write SetSelectedItem;
   end;


implementation
uses System.sysutils;

{ TViewModelForm }

constructor TRecordViewModel.Create;
begin
   FLogs := TStringList.Create;
   FLogs.Add('Start Logs');
   FLabelNome := 'Label Nome Default';

   FListObject := TListModelList<TItem>.Create(TList<TItem>.Create());
   FListObject.Add(TItem.Create(1, 'Um'));
   FListObject.Add(TItem.Create(2, 'Dois'));
   FListObject.Add(TItem.Create(3, 'Três'));

   FSelectedItem := FListObject.Get(0);
end;

destructor TRecordViewModel.Destroy;
begin
  FLogs.Free;
  FListObject.GetInnerList.Free;
  inherited;
end;

function TRecordViewModel.GetEnableEdit1: Boolean;
begin
   Result := True;
end;

function TRecordViewModel.GetItems: IListModel;
begin
   Result := FListObject;
end;

function TRecordViewModel.GetLabelNome: String;
begin
   Result := FLabelNome;
end;

function TRecordViewModel.GetMsgNumChar: String;
begin
   Result := 'Count: ' + String.parse(FPrimeiroNome.Length);
end;

function TRecordViewModel.GetNumero1: Integer;
begin
   Result := FNumero1;
end;

function TRecordViewModel.GetNumero2: Double;
begin
   Result := FNumero2;
end;

function TRecordViewModel.GetPrimeiroNome: String;
begin
   Result := FPrimeiroNome;
end;

function TRecordViewModel.GetSegundoNome: String;
begin
   Result := FSegundoNome;
end;

function TRecordViewModel.GetSelectedItem: TItem;
begin
   Result := FSelectedItem;
end;

function TRecordViewModel.GetSoma: Double;
begin
   Result := FNumero1 + FNumero2;
end;

function TRecordViewModel.GetTestDate: TDate;
begin
   Result := FTestDate;
end;

procedure TRecordViewModel.OnClick(Sender : TObject; V : Integer);
begin

   FPrimeiroNome := 'Onclick ' + Sender.ClassName;

end;

procedure TRecordViewModel.SetEnableEdit1(Enable: Boolean);
begin

   if Enable then
      FLabelCheck1 := 'Enable On'
   else
      FLabelCheck1 := 'Enable Off';

end;

procedure TRecordViewModel.SetItems(const Items: IListModel);
begin
   FListObject := Items as IListModelList<TItem>;
end;

procedure TRecordViewModel.SetLabelNome(Texto: String);
begin

end;

procedure TRecordViewModel.SetNumero1(Num: Integer);
begin
   FNumero1 := Num;
end;

procedure TRecordViewModel.SetNumero2(Num: Double);
begin
   FNumero2 := Num;
end;

procedure TRecordViewModel.SetPrimeiroNome(Nome: String);
begin
   FPrimeiroNome := Nome;
   FSegundoNome := Nome;
end;

procedure TRecordViewModel.SetSegundoNome(Nome: String);
begin
   FSegundoNome := Nome;
end;

procedure TRecordViewModel.SetSelectedItem(const Item: TItem);
begin
   FSelectedItem := Item;

//   FLogs.Add('SelectedItem: ' + Item.Text);
end;

procedure TRecordViewModel.SetTestDate(Date: TDate);
begin

   FTestDate := Date;

   FLogs.Add('TestDate: ' + FormatDateTime('dd/mm/yyyy', Date));

end;

{ TItem }

constructor TItem.Create(const AId: Integer; const AText: String);
begin
   FId := AId;
   FText := AText;
end;

initialization
TGlue.RegisterType(TRecordViewModel);

end.
