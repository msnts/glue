unit Glue.Converter;

interface

type
   IConverter<U, B, C> = interface
      ['{B2ACCF79-1872-4D60-9182-A1C1C9EDB98A}']
      function coerceToUi(BeanProp : B; Component : C) : U;
      function coerceToBean(CompAttr : U; Component : C) : B;
   end;

implementation

end.
