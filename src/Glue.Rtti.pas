unit Glue.Rtti;

interface
uses System.Rtti;

type
  TRttiTypeHelper = class helper for TRttiType
  public
    function GetMember(const AName: string): TRttiMember;
  end;

  TRttiMemberHelper = class helper for TRttiMember
  private
    function GetIsWritable: Boolean;
  public
    function GetMemberType(): TRttiType;
    function GetValue(Instance: Pointer; const AIndex: Integer): TValue;
    procedure SetValue(AInstance: Pointer; const AIndex: Integer; AValue: TValue);
    property IsWritable: Boolean read GetIsWritable;
  end;

implementation

{ TRttiMemberHelper }

function TRttiMemberHelper.GetIsWritable: Boolean;
begin
  if Self is TRttiField then
    Exit(True);

  Result := TRttiProperty(Self).IsWritable;
end;

function TRttiMemberHelper.GetMemberType: TRttiType;
begin
  if Self is TRttiField then
    Exit(TRttiField(Self).FieldType);

  if Self is TRttiInstanceProperty then
    Exit(TRttiInstanceProperty(Self).PropertyType);

  if Self is TRttiIndexedProperty then
    Exit(TRttiIndexedProperty(Self).PropertyType);

  Result := TRttiProperty(Self).PropertyType;
end;

function TRttiMemberHelper.GetValue(Instance: Pointer; const AIndex: Integer): TValue;
var
  LValue: TValue;
begin
  if Self is TRttiField then
    Exit(TRttiField(Self).GetValue(Instance));

  if Self is TRttiInstanceProperty then
  begin
    LValue := TRttiInstanceProperty(Self).GetValue(Instance);

    if LValue.IsArray then
      Exit(LValue.GetArrayElement(AIndex));

    Exit(LValue);
  end;

  if Self is TRttiIndexedProperty then
    Exit(TRttiIndexedProperty(Self).GetValue(Instance, [AIndex]));

  Result := TRttiProperty(Self).GetValue(Instance);
end;

procedure TRttiMemberHelper.SetValue(AInstance: Pointer; const AIndex: Integer; AValue: TValue);
var
  LValue: TValue;
begin
  if Self is TRttiField then
  begin
    TRttiField(Self).SetValue(AInstance, AValue);
    Exit;
  end;

  if Self is TRttiInstanceProperty then
  begin
    if AIndex < 0 then
    begin
      TRttiInstanceProperty(Self).SetValue(AInstance, AValue);
      Exit;
    end;

    LValue := TRttiInstanceProperty(Self).GetValue(AInstance);

    if LValue.IsArray then
      LValue.SetArrayElement(AIndex, AValue);

    Exit;
  end;

  if Self is TRttiIndexedProperty then
  begin
    TRttiIndexedProperty(Self).SetValue(AInstance, [AIndex], AValue);
    Exit;
  end;

  TRttiProperty(Self).SetValue(AInstance, AValue);
end;

{ TRttiTypeHelper }

function TRttiTypeHelper.GetMember(const AName: string): TRttiMember;
begin
  Result := Self.GetField(AName);
  if Result <> nil then
    Exit(Result);

  Result := Self.GetProperty(AName);
  if Result <> nil then
    Exit(Result);

  Result :=  Self.GetIndexedProperty(AName);
end;

end.
