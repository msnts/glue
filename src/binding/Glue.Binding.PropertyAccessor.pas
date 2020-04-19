unit Glue.Binding.PropertyAccessor;

interface
uses System.Rtti;

type
  IPropertyAccessor = interface
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

end.
