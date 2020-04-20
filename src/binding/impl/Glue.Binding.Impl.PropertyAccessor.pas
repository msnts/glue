unit Glue.Binding.Impl.PropertyAccessor;

interface
uses
  System.Rtti,
  System.TypInfo,
  System.SysUtils,
  Glue.Rtti,
  Glue.Binding.PropertyAccessor;

type

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
    function ResolveInstance(AInstance: TObject): Pointer;
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
  ObjectType: TRttiType;
  Count: Integer;
begin
  FIsRoot := False;
  FObjectType := AObjectType;
  FPropertyName := APropertyNames[0];
  FMemberProperty := AObjectType.GetMember(FPropertyName);
  FRootMemberProperty := FMemberProperty;
  Count := Length(APropertyNames);

  if Count = 2 then
    begin
      FObjectType := FMemberProperty.GetMemberType();
      FChild := TPropertyAccessor.Create(FObjectType, Copy(APropertyNames, 1));
    end
    else
    begin
      if Count > 2 then
      begin
        ObjectType := FMemberProperty.GetMemberType;
        FChild := TPropertyAccessor.Create(ObjectType, Copy(APropertyNames, 1));
        FObjectType := FChild.GetObjectType();
      end;
    end;
end;

constructor TPropertyAccessor.Create(AInstance: TObject; AObjectType: TRttiType; const APropertyName: string);
var
  ObjectType: TRttiType;
  properties: TArray<string>;
  Count: Integer;
begin
  FIsRoot := True;
  FInstance := AInstance;
  FFullPropertyName := APropertyName;

  FObjectType := AObjectType;
  properties := APropertyName.Split(['.']);
  Count := Length(properties);

  FPropertyName := properties[0];
  FMemberProperty := FObjectType.GetMember(FPropertyName);
  FRootMemberProperty := FMemberProperty;

  if Count = 2 then
  begin
    FObjectType := FMemberProperty.GetMemberType();
    FChild := TPropertyAccessor.Create(FObjectType, Copy(properties, 1));
  end
  else
  begin
    if Count > 2 then
    begin
      ObjectType := FMemberProperty.GetMemberType;
      FChild := TPropertyAccessor.Create(ObjectType, Copy(properties, 1));
      FObjectType := FChild.GetObjectType();
    end;
  end;

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
    Value := FRootMemberProperty.GetValue(AInstance)
  else
    Value := FMemberProperty.GetValue(AInstance);

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

function TPropertyAccessor.GetValue: TValue;
var
  LInstance: Pointer;
begin
  LInstance := ResolveInstance(FInstance);
  if FChild = nil then
    Result :=  FMemberProperty.GetValue(LInstance)
  else
    Result := FChild.GetMemberProperty.GetValue(LInstance);
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

procedure TPropertyAccessor.SetValue(AValue: TValue);
var
  LInstance: Pointer;
begin
  LInstance := ResolveInstance(FInstance);
  if FChild = nil then
    FMemberProperty.SetValue(LInstance, AValue)
  else
    FChild.GetMemberProperty.SetValue(LInstance, AValue);
end;

end.
