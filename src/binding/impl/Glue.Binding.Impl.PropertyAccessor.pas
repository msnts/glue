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
unit Glue.Binding.Impl.PropertyAccessor;

interface
uses
  System.Rtti,
  System.TypInfo,
  System.SysUtils,
  System.RegularExpressions,
  Glue.Rtti,
  Glue.Binding.PropertyAccessor;

type
  TPropertyData = record
    Identicator: string;
    Index: Integer;
  end;

  TPropertyAccessor = class(TInterfacedObject, IPropertyAccessor)
  private
    FIsRoot: Boolean;
    FInstance: Pointer;
    FFullPropertyName: string;
    FPropertyName: string;
    FMemberProperty: TRttiMember;
    FRootMemberProperty: TRttiMember;
    FObjectType: TRttiType;
    FChild: IPropertyAccessor;
    FIndex: Integer;
    function ResolveInstance(AInstance: TObject): Pointer;
    procedure SetChild(const AProperties: TArray<string>);
    function GetPropertyData(const APropertyName: string): TPropertyData;
  public
    constructor Create(AInstance: TObject; AObjectType: TRttiType; const APropertyName: string); overload;
    constructor Create(AObjectType: TRttiType; const APropertyNames: TArray<string>); overload;
    procedure SetValue(AValue: TValue);
    function GetValue(): TValue;
    function GetObjectType: TRttiType;
    function GetMemberProperty: TRttiMember;
    function GetMemberType: TTypeKind;
    function IsWritable(): boolean;
    function GetInstance(): Pointer;
    function HasChild(): Boolean;
  end;

implementation

{ TProperty }

constructor TPropertyAccessor.Create(AObjectType: TRttiType; const APropertyNames: TArray<string>);
var
  LPropertyData: TPropertyData;
begin
  FIsRoot := False;
  FObjectType := AObjectType;

  LPropertyData := GetPropertyData(APropertyNames[0]);

  FPropertyName := LPropertyData.Identicator;
  FIndex := LPropertyData.Index;

  FMemberProperty := AObjectType.GetMember(FPropertyName);
  FRootMemberProperty := FMemberProperty;

  SetChild(APropertyNames);
end;

constructor TPropertyAccessor.Create(AInstance: TObject; AObjectType: TRttiType; const APropertyName: string);
var
  LProperties: TArray<string>;
  LPropertyData: TPropertyData;
begin
  FIsRoot := True;
  FInstance := AInstance;
  FFullPropertyName := APropertyName;

  FObjectType := AObjectType;
  LProperties := APropertyName.Split(['.']);

  LPropertyData := GetPropertyData(LProperties[0]);

  FPropertyName := LPropertyData.Identicator;
  FIndex := LPropertyData.Index;
  FMemberProperty := FObjectType.GetMember(FPropertyName);
  FRootMemberProperty := FMemberProperty;

  SetChild(LProperties);

  if FChild <> nil then
    FMemberProperty := FChild.GetMemberProperty();
end;

function TPropertyAccessor.ResolveInstance(AInstance: TObject): Pointer;
var
  Value: TValue;
begin
  if FChild = nil then
    Exit(AInstance);

  if FIsRoot then
    Value := FRootMemberProperty.GetValue(AInstance, FIndex)
  else
    Value := FMemberProperty.GetValue(AInstance, FIndex);

  Result := TPropertyAccessor(FChild).ResolveInstance(Value.AsObject);
end;

function TPropertyAccessor.GetInstance: Pointer;
begin
  Result := ResolveInstance(FInstance);
end;

function TPropertyAccessor.GetMemberProperty: TRttiMember;
begin
  if FIsRoot or (FChild = nil) then
    Exit(FMemberProperty);
  Result := FChild.GetMemberProperty();
end;

function TPropertyAccessor.GetMemberType: TTypeKind;
begin
  if FChild <> nil then
    Exit(FChild.GetMemberType);
  Result := FMemberProperty.GetMemberType.TypeKind;
end;

function TPropertyAccessor.GetObjectType: TRttiType;
begin
  if FIsRoot or (FChild = nil) then
    Exit(FObjectType);
  Result := FChild.GetObjectType();
end;

function TPropertyAccessor.GetPropertyData(const APropertyName: string): TPropertyData;
var
  LMatch: TMatch;
  LPropertyData: TPropertyData;
begin
  LMatch := TRegEx.Match(APropertyName, '^(\w*)\[?(\d*)\]?$',[roIgnoreCase]);

  LPropertyData.Identicator := LMatch.Groups.Item[1].Value;
  LPropertyData.Index := StrToIntDef(LMatch.Groups.Item[2].Value, -1);

  Result := LPropertyData;
end;

function TPropertyAccessor.GetValue: TValue;
var
  LInstance: Pointer;
begin
  LInstance := ResolveInstance(FInstance);
  if FChild = nil then
    Result :=  FMemberProperty.GetValue(LInstance, FIndex)
  else
    Result := FChild.GetMemberProperty.GetValue(LInstance, FIndex);
end;

function TPropertyAccessor.HasChild: Boolean;
begin
  Result := FChild <> nil;
end;

function TPropertyAccessor.IsWritable: boolean;
begin
  if FIsRoot or (FChild = nil) then
    Exit(FMemberProperty.IsWritable);
  Result := FChild.IsWritable;
end;

procedure TPropertyAccessor.SetChild(const AProperties: TArray<string>);
var
  ObjectType: TRttiType;
  Count: Integer;
begin
  Count := Length(AProperties);
  if Count = 2 then
  begin
    FObjectType := FMemberProperty.GetMemberType();
    FChild := TPropertyAccessor.Create(FObjectType, Copy(AProperties, 1));
  end
  else
  begin
    if Count > 2 then
    begin
      ObjectType := FMemberProperty.GetMemberType;
      FChild := TPropertyAccessor.Create(ObjectType, Copy(AProperties, 1));
      FObjectType := FChild.GetObjectType();
    end;
  end;
end;

procedure TPropertyAccessor.SetValue(AValue: TValue);
var
  LInstance: Pointer;
begin
  LInstance := ResolveInstance(FInstance);
  if FChild = nil then
    FMemberProperty.SetValue(LInstance, FIndex, AValue)
  else
    FChild.GetMemberProperty.SetValue(LInstance, FIndex, AValue);
end;

end.
