unit Glue.Binding.BindingTests;

interface
uses
  DUnitX.TestFramework,
  Glue.Attributes,
  Glue.Binding,
  Glue.Converter,
  Glue.Binding.Impl.Binding,
  Glue.Converter.Impl.GenericConverter;

type

  [TestFixture]
  TBindingTests = class(TObject) 
  private
    FSourceValue: Integer;
    FTargetValue: Integer;
  public
    property SourceValue: Integer read FSourceValue write FSourceValue;
    property TargetValue: Integer read FTargetValue write FTargetValue;

    //[Test]
    procedure SimpleLoanTest;
  end;

implementation

procedure TBindingTests.SimpleLoanTest;
var
  Binding: IBinding;
  Converter: IConverter;
begin
  Converter := TGenericConverter.Create;

  Binding := TBinding.Create(Self, 'SourceValue', Self, 'TargetValue', mbLoad, Converter);

  SourceValue := 123;

  Binding.UpdateTarget;

  Assert.AreEqual(SourceValue, TargetValue);
end;

initialization
  TDUnitX.RegisterTestFixture(TBindingTests);
end.
