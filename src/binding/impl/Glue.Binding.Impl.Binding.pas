unit Glue.Binding.Impl.Binding;

interface

uses
   System.Classes,
   Vcl.StdCtrls,
   System.SysUtils,
   Rtti,
   TypInfo,
   Glue.Rtti,
   Glue.Attributes,
   Glue.Binding,
   Generics.Collections,
   Glue.Binding.BindingContext,
   Glue.Converter,
   Glue.Converter.Impl.GenericConverter,
   Glue.Exceptions,
   Glue.ViewModel.ListModel;

type
  TMemberProperty = record
  public
    Instance: TObject;
    Prop: TRttiProperty;
    PropertyType: TRttiType;
    ObjectType: TRttiType;

    procedure SetValue(AValue: TValue);
    function GetValue(): TValue;
  end;

  TBinding = class(TInterfacedObject, IBinding)
  protected
    FSource: TObject;
    FTarget: TObject;
    FBindingMode: TBindingMode;
    FRTTIContext: TRttiContext;
    FSourceProperty: TMemberProperty;
    FTargetProperty: TMemberProperty;
    FSourcePropertyName: string;
    FTargetPropertyName: string;
    FConverter : IConverter;
  protected
    procedure OnChange(Sender: TObject);
    procedure SetSource(ASource: TObject);
    procedure SetTarget(ATarget: TObject);
    procedure SetConverter(AConverter: IConverter);
    procedure SetSourceProperty();
    procedure SetTargetProperty();
    function GetRttiProperty(AInstance: TObject; const APropertyName: string): TMemberProperty;
  public
    constructor Create(ASource: TObject; ASourcePropertyName: string; ATarget: TObject;
      ATargetPropertyName: string; ABindingMode: TBindingMode; AConverter: IConverter);
    procedure UpdateTarget();
    procedure UpdateSource();
  end;

implementation

{ TBinding }

constructor TBinding.Create(ASource: TObject; ASourcePropertyName: string;
  ATarget: TObject; ATargetPropertyName: string; ABindingMode: TBindingMode;
  AConverter: IConverter);
begin
  FSourcePropertyName := ASourcePropertyName;
  FTargetPropertyName := ATargetPropertyName;
  FBindingMode := ABindingMode;

  SetSource(ASource);
  SetTarget(ATarget);
  SetConverter(AConverter);

  FRTTIContext := TRttiContext.Create;
end;

function TBinding.GetRttiProperty(AInstance: TObject; const APropertyName: string): TMemberProperty;
var
  properties: TArray<string>;
  PropName: string;
  Prop: TRttiMember;
  I, count: Integer;
  Resp: TMemberProperty;
begin
  properties := APropertyName.Split(['.']);
  count := Length(properties) - 1;

  Resp.ObjectType := FRTTIContext.GetType(AInstance.ClassType);

  Resp.Instance := AInstance;

  for I := 0 to count do
  begin
    PropName := properties[I];
    Prop := Resp.ObjectType.GetMember(PropName);
    Resp.PropertyType := Prop.GetMemberType;

    if I < count then
    begin
      Resp.Instance := Prop.GetValue(Resp.Instance).AsObject;
      Resp.ObjectType := Prop.GetMemberType;
    end;
  end;

  Resp.Prop := TRttiProperty(Prop);

  Result := Resp;
end;

procedure TBinding.OnChange(Sender: TObject);
var
   Value: TValue;
begin

   Value := FConverter.coerceToVM(FTargetProperty.GetValue, FTargetProperty.Instance);

   FSourceProperty.SetValue(Value);

end;

procedure TBinding.UpdateSource;
begin

end;

procedure TBinding.SetConverter(AConverter: IConverter);
begin
  FConverter := AConverter;
  if FConverter is TGenericConverter then
    TGenericConverter(FConverter).SetPropertiesType(FTargetProperty.Prop.PropertyType, FSourceProperty.Prop.PropertyType);
end;

procedure TBinding.SetSource(ASource: TObject);
begin
  FSource := ASource;

  FSourceProperty := GetRttiProperty(FSource, FSourcePropertyName);

  if (FBindingMode <> mbLoad) and not FSourceProperty.Prop.IsWritable then
    raise EInvalidDataBindingException.Create('Error Data Binding: The "' + FSourcePropertyName + '" Property of the ViewModel is read-only');
end;

procedure TBinding.SetSourceProperty;
begin

end;

procedure TBinding.SetTarget(ATarget: TObject);
var
  objType: TRttiType;
  Prop: TRttiProperty;
begin
  FTarget := ATarget;

  FTargetProperty := GetRttiProperty(FTarget, FTargetPropertyName);

  if (FBindingMode = mbLoad) and not FTargetProperty.Prop.IsWritable then
    raise EInvalidDataBindingException.Create('Error Data Binding: The "' + FTargetPropertyName + '" Property of the View is read-only');

   if FBindingMode = mbLoad then
      Exit;

   Prop := FTargetProperty.ObjectType.GetProperty('OnChange');

   if Prop = nil then
      Prop := FTargetProperty.ObjectType.GetProperty('OnClick');

   if Prop = nil then
      raise Exception.Create('Property OnChange not found');

   Prop.SetValue(FTargetProperty.Instance, TValue.From<TNotifyEvent>(OnChange));
end;

procedure TBinding.SetTargetProperty;
begin

end;

procedure TBinding.UpdateTarget;
var
   Value, PropertyValue: TValue;
   InterfaceValue : IInterface;
begin

   if FBindingMode = mbSave then
      Exit;

   PropertyValue := FSourceProperty.GetValue();

   Value := FConverter.coerceToUI(PropertyValue, FTarget);

   FTargetProperty.SetValue(Value);

end;

{ TMemberProperty }

function TMemberProperty.GetValue: TValue;
begin
  Result := Self.Prop.GetValue(Self.Instance);
end;

procedure TMemberProperty.SetValue(AValue: TValue);
begin
  Self.Prop.SetValue(Self.Instance, AValue);
end;

end.
