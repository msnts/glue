unit Glue.Binding.Impl.Command;

interface
uses
   System.SysUtils,
   System.Classes,
   System.Rtti,
   System.TypInfo,
   System.ObjAuto,
   Glue.Binding.Command,
   Glue.ActionListener,
   Glue.Exceptions;

type

   TCommand = class(TInterfacedObject, ICommand)
   private
      FComponent: TComponent;
      FViewModel: TObject;
      FRTTIContext: TRttiContext;
      FInternalDispatcher: TMethod;
      FHandlerMethod : TMethod;
      FTriggerName : String;
      FHandlerName : String;
      FActionListener : IActionListener;
   private
      procedure Bind;
      function GetCommandTrigger() : TRttiProperty;
      function GetCommandHandler() : TRttiMethod;
      procedure InternalInvoke(Params: PParameters; StackSize: Integer);
   public
      constructor Create(Component: TComponent; ViewModel: TObject; const TriggerName, HandlerName : String);
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
   CommandTrigger : TRttiProperty;
   CommandHandler: TRttiMethod;
   Handler : TValue;
   TriggerType : PTypeInfo;
   TriggerTypeData : PTypeData;
begin

   CommandTrigger := GetCommandTrigger;

   CommandHandler := GetCommandHandler;

   FHandlerMethod.Code := CommandHandler.CodeAddress;
   FHandlerMethod.Data := TObject(FViewModel);

   TriggerType := CommandTrigger.GetValue(FComponent).TypeInfo;

   TriggerTypeData := CommandTrigger.GetValue(FComponent).TypeData;

   FInternalDispatcher := CreateMethodPointer(InternalInvoke, TriggerTypeData);

   TValue.Make(@FInternalDispatcher, TriggerType, Handler);

   CommandTrigger.SetValue(FComponent, Handler);

end;

constructor TCommand.Create(Component: TComponent;
  ViewModel: TObject; const TriggerName, HandlerName: String);
begin

   FComponent := Component;
   FViewModel := ViewModel;

   FTriggerName := TriggerName;
   FHandlerName := HandlerName;

   FRTTIContext := TRttiContext.Create;

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

function TCommand.GetCommandHandler: TRttiMethod;
var
   ObjType: TRttiType;
begin

   ObjType := FRTTIContext.GetType(TObject(FViewModel).ClassType);

   Result := ObjType.GetMethod(FHandlerName);

   if not Assigned(Result) then
      raise ECommandHandlerNotFoundException.Create('Command Handler ' + FHandlerName.QuotedString + ' Not Found Into ViewModel');

end;

function TCommand.GetCommandTrigger: TRttiProperty;
var
   ObjType: TRttiType;
begin

   ObjType := FRTTIContext.GetType(FComponent.ClassType);

   Result := ObjType.GetProperty(FTriggerName);

   if not Assigned(Result) then
      raise ECommandTriggerNotFoundException.Create('Command Trigger ' + FTriggerName.QuotedString + ' Not Found Into View');

end;

procedure TCommand.InternalInvoke(Params: PParameters; StackSize: Integer);
var
   Method : TMethod;
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

end.
