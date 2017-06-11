unit Glue.Binding.Impl.Command;

interface
uses
   System.SysUtils,
   System.Classes,
   System.Rtti,
   System.TypInfo,
   Glue.Binding.Command,
   Glue.NotifyPropertyChanging,
   Glue.Exceptions;

type

   TCommand = class(TInterfacedObject, ICommand)
   private
      FComponent: TComponent;
      FViewModel: INotifyPropertyChanging;
      FRTTIContext: TRttiContext;
      FTriggerName : String;
      FHandlerName : String;
   private
      procedure Bind;
      function GetCommandTrigger() : TRttiProperty;
      function GetCommandHandler() : TRttiMethod;
   public
      constructor Create(Component: TComponent; ViewModel: INotifyPropertyChanging; const TriggerName, HandlerName : String);
   end;

implementation

{ TCommand }

procedure TCommand.Bind;
var
   CommandHandler : TRttiMethod;
   CommandTrigger : TRttiProperty;
   Method : TMethod;
   Handler : TValue;
   TriggerType : PTypeInfo;
begin

   CommandHandler := GetCommandHandler;

   CommandTrigger := GetCommandTrigger;

   Method.Code := CommandHandler.CodeAddress;
   Method.Data := TObject(FViewModel);

   TriggerType := CommandTrigger.GetValue(FComponent).TypeInfo;

   TValue.Make(@Method, TriggerType, Handler);

   CommandTrigger.SetValue(FComponent, Handler);

end;

constructor TCommand.Create(Component: TComponent;
  ViewModel: INotifyPropertyChanging; const TriggerName, HandlerName: String);
var
   Name : String;
begin

   FComponent := Component;
   FViewModel := ViewModel;

   FTriggerName := TriggerName;
   FHandlerName := HandlerName;

   FRTTIContext := TRttiContext.Create;

   Bind;

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

end.
