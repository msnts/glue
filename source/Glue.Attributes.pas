unit Glue.Attributes;

interface
uses
   System.RegularExpressions,
   Glue.Binding.BindingContext;

type

   TBindBaseAttribute = class(TCustomAttribute)
   private
      FBindContext : TBindContext;
   public
      constructor Create(Expression : String);
      property BindContext : TBindContext read FBindContext;
   end;

   BindAttribute = class(TBindBaseAttribute);

   LoadAttribute = class(TBindBaseAttribute);

   SaveAttribute = class(TBindBaseAttribute);

   CommandAttribute = class(TBindBaseAttribute)

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
   RegularExpression : TRegEx;
   Match : TMatch;
begin

   RegularExpression.Create('(\btarget=(\w+))|(\bsource=(\w+))|(\bif=(.[^;]+);?)|(\bbefore=([\w\.,]+))|(\bafter=([\w\.,]+))|(\bconverter=([\w\.]+))');
   Match := RegularExpression.Match(Expression);

   if Match.Success then
   begin
     FBindContext.AttributeUI := Match.Groups.Item[2].Value;

     Match := Match.NextMatch;

     FBindContext.AttributeVM := Match.Groups.Item[4].Value;
    // FBindContext.Condition := Match.Groups.Item[6].Value;
    // FBindContext.Before := Match.Groups.Item[8].Value;
    // FBindContext.After := Match.Groups.Item[10].Value;
     
   end;

end;

{ ConverterAttribute }

constructor ConverterAttribute.Create(ClassName: String);
begin
   FClassName := ClassName;
end;

end.
