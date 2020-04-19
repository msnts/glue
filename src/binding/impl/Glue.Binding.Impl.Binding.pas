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
   Glue.Binding.PropertyAccessor,
   Generics.Collections,
   Glue.Binding.BindingContext,
   Glue.Binding.Impl.PropertyAccessor,
   Glue.Converter,
   Glue.Converter.Impl.GenericConverter,
   Glue.Exceptions,
   Glue.ViewModel.ListModel;

type
  TBinding = class(TInterfacedObject, IBinding)
  protected
    FSource: TObject;
    FTarget: TObject;
    FBindingMode: TBindingMode;
    FRTTIContext: TRttiContext;
    FSourceProperty: IPropertyAccessor;
    FTargetProperty: IPropertyAccessor;
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
end;

procedure TBinding.OnChange(Sender: TObject);
var
  Value, PropertyValue: TValue;
  InterfaceValue : IInterface;
  vlr: string;
begin
  vlr := TEdit(Sender).Text;
  PropertyValue := FTargetProperty.GetValue();
  vlr := PropertyValue.AsString;

  Value := FConverter.coerceToVM(PropertyValue, FTarget);

  FSourceProperty.SetValue(Value);
end;

procedure TBinding.UpdateSource;
begin

end;

procedure TBinding.SetConverter(AConverter: IConverter);
begin
  FConverter := AConverter;
  if FConverter is TGenericConverter then
    TGenericConverter(FConverter).SetPropertiesType(FTargetProperty.GetMemberType, FSourceProperty.GetMemberType);
end;

procedure TBinding.SetSource(ASource: TObject);
begin
  FSource := ASource;

  FSourceProperty := TPropertyAccessor.Create(FSource, FSourcePropertyName);

  if (FBindingMode <> mbLoad) and not FSourceProperty.IsWritable then
    raise EInvalidDataBindingException.Create('Error Data Binding: The "' + FSourcePropertyName + '" Property of the ViewModel is read-only');
end;

procedure TBinding.SetSourceProperty;
begin

end;

procedure TBinding.SetTarget(ATarget: TObject);
var
  Prop: TRttiProperty;
begin
  FTarget := ATarget;

  FTargetProperty := TPropertyAccessor.Create(FTarget, FTargetPropertyName);

  if (FBindingMode = mbLoad) and not FTargetProperty.IsWritable then
    raise EInvalidDataBindingException.Create('Error Data Binding: The "' + FTargetPropertyName + '" Property of the View is read-only');

   if FBindingMode = mbLoad then
      Exit;

   Prop := FTargetProperty.GetObjectType().GetProperty('OnChange');

   if Prop = nil then
      Prop := FTargetProperty.GetObjectType().GetProperty('OnClick');

   if Prop = nil then
      raise Exception.Create('Property OnChange not found');

   Prop.SetValue(FTargetProperty.GetInstance(), TValue.From<TNotifyEvent>(OnChange));
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

end.
