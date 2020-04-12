unit Glue.Rtti;

interface
uses System.Rtti;

type
  TRttiTypeHelper = class helper for TRttiType
  public
    function GetMember(const AName: string): TRttiMember;
  end;

  TRttiMemberHelper = class helper for TRttiMember
  public
    function GetMemberType(): TRttiType;
    function GetValue(Instance: Pointer): TValue;
  end;

implementation

{ TRttiMemberHelper }

function TRttiMemberHelper.GetMemberType: TRttiType;
begin
  if Self is TRttiField then
    Exit(TRttiField(Self).FieldType);

  Result := TRttiProperty(Self).PropertyType;
end;

function TRttiMemberHelper.GetValue(Instance: Pointer): TValue;
begin
  if Self is TRttiField then
    Exit(TRttiField(Self).GetValue(Instance));

  Result := TRttiProperty(Self).GetValue(Instance);
end;

{ TRttiTypeHelper }

function TRttiTypeHelper.GetMember(const AName: string): TRttiMember;
begin
  Result := Self.GetField(AName);
  if Result <> nil then
    Exit(Result);

  Result := Self.GetProperty(AName);
end;

end.
