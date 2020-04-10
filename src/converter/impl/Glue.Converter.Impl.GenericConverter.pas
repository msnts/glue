unit Glue.Converter.Impl.GenericConverter;

interface
uses
   Glue.Converter,
   System.Rtti,
   System.TypInfo,
   System.Classes,
   System.Generics.Collections;

type
   TGenericConverter = class(TInterfacedObject, IConverter)
   private
      FPropertyTypeUI : TRttiType;
      FPropertyTypeVM : TRttiType;
   private
      function ValueToString(Value : TValue) : String;
      function ValueFromEnumeration(Value : TValue) : TValue;
      function ValueFromInterface(Value : TValue) : TValue;
   public
      procedure SetPropertiesType(PropertyTypeUI, PropertyTypeVM : TRttiType);
      function coerceToUI(Value : TValue; Component : TComponent) : TValue;
      function coerceToVM(Value : TValue; Component : TComponent) : TValue;
   end;

   TVirtualData = class(TVirtualInterface)
   private
      FData: TDictionary<string, TValue>;
      procedure DoInvoke(Method: TRttiMethod; const Args: TArray<TValue>;
        out Result: TValue);
   public
      constructor Create(PIID: PTypeInfo);
      destructor Destroy; override;
   end;

implementation
uses System.SysUtils, System.SysConst, Glue.Exceptions;


{ TGenericConverter }

function TGenericConverter.coerceToUI(Value: TValue;
  Component: TComponent): TValue;
begin

   case FPropertyTypeUI.TypeKind of
      tkInteger, tkInt64 : Result := Integer.Parse(ValueToString(Value));
      tkFloat: Result := Double.Parse(ValueToString(Value));
      tkString, tkLString, tkWString, tkUString : Result := ValueToString(Value);
      tkEnumeration: Result := ValueFromEnumeration(Value);
      tkClass: Result := Value.AsObject;
      tkInterface : Result := ValueFromInterface(Value);
   else
      raise Exception.Create('Unsupported data conversion');
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
begin

   if not FPropertyTypeVM.Name.Equals(FPropertyTypeUI.Name) then
      raise EIncompatibleDataConversionException.Create('Incompatible Data Conversion');

   Result := Value;

end;

function TGenericConverter.ValueFromInterface(Value: TValue): TValue;
var
   propertyType: PTypeInfo;
   data : IInterface;
begin

   propertyType := FPropertyTypeUI.Handle;

   if not Value.TryCast(propertyType, Result) then
      raise EIncompatibleDataConversionException.Create('Incompatible Data Conversion');

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

{ TVirtualData }

constructor TVirtualData.Create(PIID: PTypeInfo);
begin
  inherited Create(PIID, DoInvoke);
  FData := TDictionary<string, TValue>.Create;
end;

destructor TVirtualData.Destroy;
begin
  FData.Free;
  inherited Destroy;
end;

procedure TVirtualData.DoInvoke(Method: TRttiMethod;
                                const Args: TArray<TValue>;
                                out Result: TValue);
var
  key: string;
begin
  if (Pos('Get', Method.Name) = 1) then
  begin
    key := Copy(Method.Name, 4, MaxInt);
    FData.TryGetValue(key, Result);
  end;

  if (Pos('Set', Method.Name) = 1) then
  begin
    key := Copy(Method.Name, 4, MaxInt);
    FData.AddOrSetValue(key, Args[1]);
  end;
end;

end.
