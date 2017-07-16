unit Glue.ViewModel.ListModel;

interface
uses
   Glue.ViewModel.ListDataListener;

type

   IListModel = interface(IInterface)
      ['{D79A3C4C-75AC-4DCC-8B7C-86D2C384E9B9}']
      procedure AddListDataListener(Listener: IListDataListener);
      procedure RemoveListDataListener(Listener: IListDataListener);
      function GetElementAt(const Index : Integer) : TObject;
      function GetSize(): Integer;
   end;

implementation

end.
