unit Glue.ViewModel.ListModelList;

interface
uses
   System.Generics.Collections,
   Glue.ViewModel.ListModel;

type

   IListModelList<T> = interface(IListModel)
      ['{BBAB05B3-ED0E-45F3-88AA-6B304E6C304B}']
      function Add(Element: T): Boolean; overload;
      procedure Add(const Index: Integer; Element: T); overload;
      function AddToSelection(Element: T) : Boolean;
      procedure ClearSelection();
      procedure Clear;
      function Contains(Element: T): Boolean;
      function Get(const Index: Integer): T;
      function GetInnerList(): TList<T>;
      function GetSelection(): TList<T>;
      function IndexOf(Element: T): Integer;
      function IsEmpty(): Boolean;
      function IsSelectionEmpty(): Boolean;
      function Remove(const Index: Integer): T; overload;
      function Remove(Element: T): Boolean; overload;
      function RemoveAll(Elements: TList<T>): Boolean;
      procedure RemoveAllSelection(Elements: TList<T>);
      procedure RemoveRange(const FromIndex, ToIndex: Integer);
      procedure RemoveFromSelection(Element: T);
      function SetElement(const Index: Integer; Element: T): T;
      procedure SetSelection(Elements: TList<T>);
      function SubList(const FromIndex, ToIndex: Integer): TList<T>;
   end;

implementation

end.
