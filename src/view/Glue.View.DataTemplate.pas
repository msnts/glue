unit Glue.View.DataTemplate;

interface
uses
   System.Rtti,
   System.TypInfo,
   System.Bindings.Consts,
   System.Bindings.EvalProtocol,
   System.Bindings.Evaluator,
   System.Bindings.EvalSys,
   System.Bindings.ObjEval,
   System.Bindings.Methods,
   System.SysUtils,
   System.RegularExpressions,
   Glue.Exceptions;

type

   IDataTemplate = interface
      function Evaluate(const Obj : TObject) : string;
   end;

   TDataTemplate = class(TInterfacedObject, IDataTemplate)
   private
      FExpression : string;
      FModelName : string;
      FModelTemplate : string;
      FScope : IScope;
      FDictionaryScope: TDictionaryScope;

      procedure Init();
      procedure PreProcessingTemplate();
   public
      constructor Create(const Expression : string);
      function Evaluate(const Obj : TObject) : string;
   end;

implementation

{ TDataTemplate }

constructor TDataTemplate.Create(const Expression: string);
begin

   FExpression := Expression;

   PreProcessingTemplate;

   Init;

end;

function TDataTemplate.Evaluate(const Obj: TObject): string;
var
   LCompiledExpr: ICompiledBinding;
   LResult: TValue;
begin

   FDictionaryScope.Map.Clear;

   FDictionaryScope.Map.Add(FModelName, WrapObject(Obj));

   LCompiledExpr := Compile(FModelTemplate, FScope);

   try

      LResult := LCompiledExpr.Evaluate(FScope, nil, nil).GetValue;

      Result := LResult.AsString;

   except
      raise EInvalidDataTemplateException.Create('Invalid Data Template "' + FExpression + '"');
   end;

end;

procedure TDataTemplate.Init;
var
   LScope: IScope;
begin

   LScope := TNestedScope.Create(BasicOperators, BasicConstants);

   LScope := TNestedScope.Create(LScope, TBindingMethodsFactory.GetMethodScope);

   FDictionaryScope := TDictionaryScope.Create;

   FScope := TNestedScope.Create(LScope, FDictionaryScope);

end;

procedure TDataTemplate.PreProcessingTemplate();
var
   RegularExpression: TRegEx;
   Match: TMatch;
   ModelName : string;
begin

   RegularExpression.Create('({\w+})');

   Match := RegularExpression.Match(FExpression);

   if Match.Success then
   begin
      ModelName := Match.Groups.Item[1].Value;

      FModelName := TRegEx.Replace(ModelName, '{|}', '_');

      FModelTemplate := TRegEx.Replace(FExpression, ModelName, FModelName);
   end
   else
   begin
      FModelName := EmptyStr;
      FModelTemplate := FExpression;
   end;

end;

end.
