unit Glue.Binding.PropertyAccessorTests;

interface
uses
  System.Rtti,
  System.TypInfo,
  DUnitX.TestFramework,
  Glue.Binding.PropertyAccessor,
  Glue.Binding.Impl.PropertyAccessor;

type
  TCountry = class
  private
    FAlias: string;
    FGNP: Double;
    FUUID: string;
    FName: string;
  public
    property Alias: string read FAlias write FAlias;
    property GNP: Double read FGNP write FGNP;
    property Name: string read FName write FName;
    property UUID: string read FUUID;
  end;

  TCity = class
  private
    FCountry: TCountry;
    FUUID: string;
    FName: string;
  public
    property Country: TCountry read FCountry write FCountry;
    property Name: string read FName write FName;
    property UUID: string read FUUID;
  end;

  TAddress = class
  private
    FUUID: string;
    FCity: TCity;
    FId: Integer;
  public
    property City: TCity read FCity write FCity;
    property Id: Integer read FId write FId;
    property UUID: string read FUUID;
  end;

  TCustomer = class
  private
    FUUID: string;
    FAddress: TAddress;
    FFirstName: string;
  public
    property Address: TAddress read FAddress write FAddress;
    property FirstName: string read FFirstName write FFirstName;
    property UUID: string read FUUID;
  end;

  [TestFixture]
  TPropertyAccessorTests = class(TObject)
  private
    FData: TCustomer;
    FObjectType: TRttiType;
  public
    [SetupFixture]
    procedure SetupFixture();

    [TearDownFixture]
    procedure TearDownFixture();

    [TestCase('Single', 'FirstName,tkUString')]
    [TestCase('Double', 'Address.Id,tkInteger')]
    [TestCase('Triple', 'Address.City.Name,tkUString')]
    [TestCase('Quadruple', 'Address.City.Country.GNP,tkFloat')]
    procedure GetMemberType_ShouldReturnPropertyKindCorrectly(const APropertyName: string; const AExpected: TTypeKind);

    [TestCase('Single', 'FirstName,Bob')]
    [TestCase('Double', 'Address.Id,123')]
    [TestCase('Triple', 'Address.City.Name,Rio')]
    [TestCase('Quadruple', 'Address.City.Country.Alias,BR')]
    procedure GetValue_ShouldReturnPropertyValueCorrectly(const APropertyName: string; AExpectedName: variant);

    [TestCase('Single', 'FirstName,FirstName')]
    [TestCase('Double', 'Address.Id,Id')]
    [TestCase('Triple', 'Address.City.Name,Name')]
    [TestCase('Quadruple', 'Address.City.Country.Alias,Alias')]
    procedure GetMemberProperty_ShouldReturnPropertyCorrectly(const APropertyName, AExpectedName: string);

    [TestCase('Single - True', 'FirstName,True')]
    [TestCase('Single - False', 'UUID,False')]
    [TestCase('Double - True', 'Address.Id,True')]
    [TestCase('Double - False', 'Address.UUID,False')]
    [TestCase('Triple - True', 'Address.City.Name,True')]
    [TestCase('Triple - False', 'Address.City.UUID,False')]
    procedure IsWritable_ShouldReturnValueCorrectly(const APropertyName: string; const AExpected: Boolean);

    [TestCase('Single', 'FirstName,TCustomer')]
    [TestCase('Double', 'Address.Id,TAddress')]
    [TestCase('Triple', 'Address.City.Name,TCity')]
    [TestCase('Quadruple', 'Address.City.Country.Alias,TCountry')]
    procedure GetObjectType_ShouldReturnValueCorrectly(const APropertyName, AExpectedName: string);

    [Test]
    procedure GetInstance_GivenAPropertyNameWithOneLevel_ShouldReturnValueCorrectly();

    [Test]
    procedure GetInstance_GivenAPropertyNameWithTwoLevel_ShouldReturnValueCorrectly();

    [Test]
    procedure GetInstance_GivenAPropertyNameWithThreeLevel_ShouldReturnValueCorrectly();

    [Test]
    procedure GetInstance_GivenAPropertyNameWithFourLevel_ShouldReturnValueCorrectly;
  end;

implementation


{ TPropertyAccessorTests }

procedure TPropertyAccessorTests.GetValue_ShouldReturnPropertyValueCorrectly(const APropertyName: string; AExpectedName: variant);
var
  Accessor: IPropertyAccessor;
begin
  Accessor := TPropertyAccessor.Create(FData, FObjectType, APropertyName);

  Assert.AreEqual(AExpectedName, Accessor.GetValue.AsVariant);
end;

procedure TPropertyAccessorTests.IsWritable_ShouldReturnValueCorrectly(
  const APropertyName: string; const AExpected: Boolean);
var
  Accessor: IPropertyAccessor;
begin
  Accessor := TPropertyAccessor.Create(FData, FObjectType, APropertyName);

  Assert.AreEqual(AExpected, Accessor.IsWritable);
end;

procedure TPropertyAccessorTests.GetInstance_GivenAPropertyNameWithOneLevel_ShouldReturnValueCorrectly;
var
  Accessor: IPropertyAccessor;
begin
  Accessor := TPropertyAccessor.Create(FData, FObjectType, 'FirstName');

  Assert.AreSame(FData, Accessor.GetInstance());
end;

procedure TPropertyAccessorTests.GetInstance_GivenAPropertyNameWithThreeLevel_ShouldReturnValueCorrectly;
var
  Accessor: IPropertyAccessor;
begin
  Accessor := TPropertyAccessor.Create(FData, FObjectType, 'Address.City.Name');

  Assert.AreSame(FData.Address.City, Accessor.GetInstance());
end;

procedure TPropertyAccessorTests.GetInstance_GivenAPropertyNameWithTwoLevel_ShouldReturnValueCorrectly;
var
  Accessor: IPropertyAccessor;
begin
  Accessor := TPropertyAccessor.Create(FData, FObjectType, 'Address.Id');

  Assert.AreSame(FData.Address, Accessor.GetInstance());
end;

procedure
    TPropertyAccessorTests.GetInstance_GivenAPropertyNameWithFourLevel_ShouldReturnValueCorrectly;
var
  Accessor: IPropertyAccessor;
begin
  Accessor := TPropertyAccessor.Create(FData, FObjectType, 'Address.City.Country.Alias');

  Assert.AreSame(FData.Address.City.Country, Accessor.GetInstance());
end;

procedure TPropertyAccessorTests.GetMemberProperty_ShouldReturnPropertyCorrectly(
  const APropertyName, AExpectedName: string);
var
  Accessor: IPropertyAccessor;
begin
  Accessor := TPropertyAccessor.Create(FData, FObjectType, APropertyName);

  Assert.AreEqual(AExpectedName, Accessor.GetMemberProperty.Name);
end;

procedure TPropertyAccessorTests.GetMemberType_ShouldReturnPropertyKindCorrectly(
  const APropertyName: string; const AExpected: TTypeKind);
var
  Accessor: IPropertyAccessor;
begin
  Accessor := TPropertyAccessor.Create(FData, FObjectType, APropertyName);

  Assert.AreEqual(AExpected, Accessor.GetMemberType);
end;

procedure TPropertyAccessorTests.GetObjectType_ShouldReturnValueCorrectly(const APropertyName, AExpectedName: string);
var
  Accessor: IPropertyAccessor;
begin
  Accessor := TPropertyAccessor.Create(FData, FObjectType, APropertyName);

  Assert.AreEqual(AExpectedName, Accessor.GetObjectType.Name);
end;

procedure TPropertyAccessorTests.SetupFixture;
var
  LRTTIContext: TRttiContext;
begin
  FData := TCustomer.Create;
  FData.Address := TAddress.Create;
  FData.Address.FCity := TCity.Create;

  FData.FirstName := 'Bob';
  FData.Address.Id := 123;
  FData.Address.City.Name := 'Rio';

  FData.Address.City.Country := TCountry.Create;
  FData.Address.City.Country.Name := 'Brazil';
  FData.Address.City.Country.Alias := 'BR';

  LRTTIContext := TRttiContext.Create;
  try
    FObjectType := LRTTIContext.GetType(FData.ClassType);
  finally
    LRTTIContext.Free;
  end;
end;

procedure TPropertyAccessorTests.TearDownFixture;
begin
  FData.Address.City.Country.Free;
  FData.Address.City.Free;
  FData.Address.Free;
  FData.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TPropertyAccessorTests);
end.
