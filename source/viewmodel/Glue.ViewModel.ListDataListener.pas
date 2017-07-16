unit Glue.ViewModel.ListDataListener;

interface
uses
   System.Generics.Collections;

type

   IListDataListener = interface
      ['{A91F8300-33B3-4C11-ADAA-E57B6EB71087}']
      procedure OnSelectionChange(const Selection : TList<TObject>);
      procedure OnDataChange();
   end;

implementation

end.
