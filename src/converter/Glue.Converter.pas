unit Glue.Converter;

interface
uses
   System.Rtti,
   System.Classes;

type
   IConverter = interface
      ['{B2ACCF79-1872-4D60-9182-A1C1C9EDB98A}']
      function CoerceToUI(Value : TValue; ATarget : TObject) : TValue;
      function CoerceToVM(Value : TValue; ATarget : TObject) : TValue;
   end;

implementation

end.
