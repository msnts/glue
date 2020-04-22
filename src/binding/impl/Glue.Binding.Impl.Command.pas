unit Glue.Binding.Impl.Command;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Rtti,
  System.TypInfo,
  System.ObjAuto,
  Glue.Binding.PropertyAccessor,
  Glue.Binding.Impl.PropertyAccessor,
  Glue.Binding.Command,
  Glue.ActionListener,
  Glue.Exceptions;

type

  TCommand = class(TInterfacedObject, ICommand)
  private
    FSource: TObject;
    FTarget: TObject;
    FSourceType: TRttiType;
    FTargetType: TRttiType;
    FTargetProperty: IPropertyAccessor;
    FInternalDispatcher: TMethod;
    FHandlerMethod: TMethod;
    FTriggerName: string;
    FHandlerName: string;
    FActionListener: IActionListener;
  private
    procedure Bind;
    procedure InternalInvoke(Params: PParameters; StackSize: Integer);
    procedure SetHandlerMethod;
    procedure SetTriggerProperty;
  public
    constructor Create(ASourceType: TRttiType; ASource: TObject; ATargetType: TRttiType; ATarget: TObject;
      const ATriggerName, AHandlerName: string);
    destructor Destroy(); override;
    procedure Attach(Listener: IActionListener);
    procedure Detach(Listener: IActionListener);
  end;

implementation

{ TCommand }

procedure TCommand.Attach(Listener: IActionListener);
begin
  FActionListener := Listener;
end;

procedure TCommand.Bind;
var
  Handler: TValue;
  TriggerValue: TValue;
begin
  SetHandlerMethod;

  TriggerValue := FTargetProperty.GetValue();

  FInternalDispatcher := CreateMethodPointer(InternalInvoke, TriggerValue.TypeData);

  TValue.Make(@FInternalDispatcher, TriggerValue.TypeInfo, Handler);

  FTargetProperty.SetValue(Handler);
end;

constructor TCommand.Create(ASourceType: TRttiType; ASource: TObject;
  ATargetType: TRttiType; ATarget: TObject;
  const ATriggerName, AHandlerName: String);
begin
  FSourceType := ASourceType;
  FTargetType := ATargetType;
  FSource := ASource;
  FTarget := ATarget;

  FTriggerName := ATriggerName;
  FHandlerName := AHandlerName;

  SetTriggerProperty;

  Bind;
end;

destructor TCommand.Destroy;
begin
  ReleaseMethodPointer(FInternalDispatcher);
  inherited;
end;

procedure TCommand.Detach(Listener: IActionListener);
begin
  FActionListener := nil;
end;

procedure TCommand.InternalInvoke(Params: PParameters; StackSize: Integer);
var
  Method: TMethod;
begin
  Method := FHandlerMethod;

  if Assigned(FActionListener) then
    FActionListener.OnBeforeAction(FHandlerName);

  if StackSize > 0 then
  begin
    asm
      MOV ECX,StackSize
      SUB ESP,ECX
      MOV EDX,ESP
      MOV EAX,Params
      LEA EAX,[EAX].TParameters.Stack[8]
      CALL System.Move
    end;
  end;

  asm
    MOV EAX,Params
    MOV EDX,[EAX].TParameters.Registers.DWORD[0]
    MOV ECX,[EAX].TParameters.Registers.DWORD[4]

    MOV EAX,Method.Data

    CALL Method.Code
  end;

  if Assigned(FActionListener) then
    FActionListener.OnAfterAction(FHandlerName);
end;

procedure TCommand.SetHandlerMethod;
var
  LMethod: TRttiMethod;
begin
  LMethod := FSourceType.GetMethod(FHandlerName);

  if not Assigned(LMethod) then
    raise ECommandHandlerNotFoundException.Create('Command Handler ' + FHandlerName.QuotedString + ' Not Found Into ViewModel');

  FHandlerMethod.Code := LMethod.CodeAddress;
  FHandlerMethod.Data := FSource;
end;

procedure TCommand.SetTriggerProperty;
begin
  try
    FTargetProperty := TPropertyAccessor.Create(FTarget, FTargetType, FTriggerName);
  except
    on E: Exception do
      raise ECommandTriggerNotFoundException.Create('Command Trigger ' + FTriggerName.QuotedString + ' Not Found Into View');
  end;
end;

end.
