unit Glue.Attributes;

interface
uses
   System.RegularExpressions,
   Glue.Binding.BindingContext,
   Glue.Enum;

type

   TBindBaseAttribute = class(TCustomAttribute)
   private
      FBindContext : TBindContext;
      FMode : TModeBinding;
   public
      constructor Create(Expression : String); virtual;
      property BindContext : TBindContext read FBindContext;
      property Mode : TModeBinding read FMode;
   end;

   BindAttribute = class(TBindBaseAttribute);

   LoadAttribute = class(TBindBaseAttribute)
   public
      constructor Create(Expression : String); override;
   end;

   SaveAttribute = class(TBindBaseAttribute)
   public
      constructor Create(Expression : String); override;
   end;

   CommandAttribute = class(TCustomAttribute)
   private
      FTriggerName : String;
      FMethodName : String;
   public
      constructor Create(MethodName : String); overload;
      constructor Create(TriggerName, MethodName : String); overload;
      property TriggerName : String read FTriggerName;
      property MethodName : String read FMethodName;
   end;

   ViewModelAttribute = class(TCustomAttribute)
   private
      FClassName : String;
   public
      constructor Create(ClassName : String);
      property ClassName : String read FClassName;
   end;

   ConverterAttribute = class(TCustomAttribute)
   private
      FClassName : String;
   public
      constructor Create(ClassName : String);
      property ClassName : String read FClassName;
   end;

implementation

{ ViewModelAttribute }

constructor ViewModelAttribute.Create(ClassName: String);
begin
   FClassName := ClassName;
end;

{ TBindBaseAttribute }

constructor TBindBaseAttribute.Create(Expression: String);
var
   RegularExpression: TRegEx;
   Match: TMatch;
begin

   FMode := mbSaveLoad;

   RegularExpression.Create
     ('(\btarget=(\w+))|(\bsource=(\w+))|(\bif=(.[^;]+);?)|(\bbefore=([\w\.,]+))|(\bafter=([\w\.,]+))|(\bconverter=([\w\.]+))');
   Match := RegularExpression.Match(Expression);

   if Match.Success then
   begin
      FBindContext.AttributeUI := Match.Groups.Item[2].Value;

      Match := Match.NextMatch;

      if Match.Success then
         FBindContext.AttributeVM := Match.Groups.Item[4].Value;

      Match := Match.NextMatch;

      if Match.Success then
         FBindContext.Condition := Match.Groups.Item[6].Value;

      Match := Match.NextMatch;

      if Match.Success then
         FBindContext.Condition := Match.Groups.Item[8].Value;

      Match := Match.NextMatch;

      if Match.Success then
         FBindContext.After := Match.Groups.Item[10].Value;

   end;

end;

{ ConverterAttribute }

constructor ConverterAttribute.Create(ClassName: String);
begin
   FClassName := ClassName;
end;

{ LoadAttribute }

constructor LoadAttribute.Create(Expression: String);
begin
  inherited;
  FMode := mbLoad;
end;

{ SaveAttribute }

constructor SaveAttribute.Create(Expression: String);
begin
  inherited;
  FMode := mbSave;
end;

{ CommandAttribute }

constructor CommandAttribute.Create(MethodName: String);
begin
   FTriggerName := 'Default';
   FMethodName := MethodName;
end;

constructor CommandAttribute.Create(TriggerName, MethodName: String);
begin
   FTriggerName := TriggerName;
   FMethodName := MethodName;
end;

end.
