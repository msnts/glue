unit Glue.Attributes.TBindAttributeTests;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TBindAttributeTests = class(TObject) 
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure TBindAttributeTests.Setup;
begin
end;

procedure TBindAttributeTests.TearDown;
begin
end;

procedure TBindAttributeTests.Test1;
begin
end;

procedure TBindAttributeTests.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TBindAttributeTests);
end.
