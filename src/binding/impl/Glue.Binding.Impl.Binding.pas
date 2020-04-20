{ ******************************************************************************
  Copyright 2020 Marcos Santos

  Contact: marcos.santos@outlook.com

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  *****************************************************************************}
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
    FSourceType: TRttiType;
    FTargetType: TRttiType;
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
    constructor Create(ASourceType: TRttiType; ASource: TObject;
        ASourcePropertyName: string; ATargetType: TRttiType; ATarget: TObject;
        ATargetPropertyName: string; ABindingMode: TBindingMode; AConverter:
        IConverter);
    procedure UpdateTarget();
    procedure UpdateSource();
  end;

implementation

{ TBinding }

constructor TBinding.Create(ASourceType: TRttiType; ASource: TObject; ASourcePropertyName: string;
  ATargetType: TRttiType; ATarget: TObject; ATargetPropertyName: string; ABindingMode: TBindingMode;
  AConverter: IConverter);
begin
  FSourceType := ASourceType;
  FTargetType := ATargetType;
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
begin
  PropertyValue := FTargetProperty.GetValue();

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

  FSourceProperty := TPropertyAccessor.Create(FSource, FSourceType, FSourcePropertyName);

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

  FTargetProperty := TPropertyAccessor.Create(FTarget, FTargetType, FTargetPropertyName);

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
begin
  if FBindingMode = mbSave then
    Exit;

  PropertyValue := FSourceProperty.GetValue();

  Value := FConverter.coerceToUI(PropertyValue, FTarget);

  FTargetProperty.SetValue(Value);
end;

end.
