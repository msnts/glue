unit Glue.Converter.Impl.GenericConverter;

interface
uses
   Glue.Converter,
   System.Rtti,
   System.TypInfo,
   System.Classes;

type
   TGenericConverter = class(TInterfacedObject, IConverter)
   private
      FTypeInfoUI : TTypeKind;
      FTypeInfoVM : TTypeKind;
   private
      function ValueToString(Value : TValue) : String;
   public
      constructor Create(TypeInfoUI, TypeInfoVM : TTypeKind);
      function coerceToUI(Value : TValue; Component : TComponent) : TValue;
      function coerceToVM(Value : TValue; Component : TComponent) : TValue;
   end;

implementation
uses System.SysUtils;


{ TGenericConverter }

function TGenericConverter.coerceToUI(Value: TValue;
  Component: TComponent): TValue;
begin

   case FTypeInfoUI of
      tkInteger, tkInt64 : Result := Integer.Parse(ValueToString(Value));
      tkFloat: Result := Double.Parse(ValueToString(Value));
      tkString, tkLString, tkWString, tkUString : Result := ValueToString(Value);
   end;

end;

function TGenericConverter.coerceToVM(Value: TValue;
  Component: TComponent): TValue;
begin

   case FTypeInfoVM of
      tkInteger, tkInt64 : Result := Integer.Parse(ValueToString(Value));
      tkFloat: Result := Double.Parse(ValueToString(Value));
      tkString, tkLString, tkWString, tkUString : Result := ValueToString(Value);
   end;

end;

constructor TGenericConverter.Create(TypeInfoUI, TypeInfoVM: TTypeKind);
begin
   FTypeInfoUI := TypeInfoUI;
   FTypeInfoVM := TypeInfoVM;
end;

function TGenericConverter.ValueToString(Value: TValue): String;
begin

   case Value.Kind of
      tkInteger : Result := String.Parse(VAlue.AsInteger);
      tkInt64 : Result := String.Parse(VAlue.AsInt64);
      tkFloat : Result := String.Parse(VAlue.AsExtended);
      tkString, tkLString, tkWString, tkUString : Result := value.AsString;
   end;
end;

end.
