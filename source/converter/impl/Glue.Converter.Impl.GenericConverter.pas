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
      FPropertyTypeUI : TRttiType;
      FPropertyTypeVM : TRttiType;
   private
      function ValueToString(Value : TValue) : String;
      function ValueFromEnumeration(Value : TValue) : TValue;
   public
      procedure SetPropertiesType(PropertyTypeUI, PropertyTypeVM : TRttiType);
      function coerceToUI(Value : TValue; Component : TComponent) : TValue;
      function coerceToVM(Value : TValue; Component : TComponent) : TValue;
   end;

implementation
uses System.SysUtils, Glue.Exceptions;


{ TGenericConverter }

function TGenericConverter.coerceToUI(Value: TValue;
  Component: TComponent): TValue;
begin

   case FPropertyTypeUI.TypeKind of
      tkInteger, tkInt64 : Result := Integer.Parse(ValueToString(Value));
      tkFloat: Result := Double.Parse(ValueToString(Value));
      tkString, tkLString, tkWString, tkUString : Result := ValueToString(Value);
      tkEnumeration: Result := ValueFromEnumeration(Value);
   end;

end;

function TGenericConverter.coerceToVM(Value: TValue;
  Component: TComponent): TValue;
begin

   case FPropertyTypeVM.TypeKind of
      tkInteger, tkInt64 : Result := Integer.Parse(ValueToString(Value));
      tkFloat: Result := Double.Parse(ValueToString(Value));
      tkString, tkLString, tkWString, tkUString : Result := ValueToString(Value);
      tkEnumeration: Result := ValueFromEnumeration(Value);
   end;

end;

procedure TGenericConverter.SetPropertiesType(PropertyTypeUI,
  PropertyTypeVM: TRttiType);
begin
   FPropertyTypeUI := PropertyTypeUI;
   FPropertyTypeVM := PropertyTypeVM;
end;

function TGenericConverter.ValueFromEnumeration(Value: TValue): TValue;
var
   Name : String;
begin

   if not FPropertyTypeVM.Name.Equals(FPropertyTypeUI.Name) then
      raise EIncompatibleDataConversionException.Create('Incompatible Data Conversion');

   Result := Value;

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
