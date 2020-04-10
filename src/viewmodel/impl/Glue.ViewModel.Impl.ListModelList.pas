unit Glue.ViewModel.Impl.ListModelList;

interface

uses
   System.Generics.Collections,
   Glue.ViewModel.ListModelList,
   Glue.ViewModel.ListDataListener;

type
   TListModelList<T:class> = class(TInterfacedObject, IListModelList<T>)
   private
      FInnerList : TList<T>;
      FSelectionList : TList<T>;
      FListDataListener : IListDataListener;
   private
      procedure NotifySelectionChange();
      procedure NotifyDataChange();
   public
      constructor Create(Elements : TList<T>);
      function Add(Element: T): Boolean; overload;
      procedure Add(const Index: Integer; Element: T); overload;
      procedure AddListDataListener(Listener: IListDataListener);
      function AddToSelection(Element: T) : Boolean;
      procedure ClearSelection();
      procedure Clear;
      function Contains(Element: T): Boolean;
      function Get(const Index: Integer): T;
      function GetElementAt(const Index : Integer) : TObject;
      function GetInnerList(): TList<T>;
      function GetSelection(): TList<T>;
      function GetSize(): Integer;
      function IndexOf(Element: T): Integer;
      function IsEmpty(): Boolean;
      function IsSelectionEmpty(): Boolean;
      function Remove(const Index: Integer): T; overload;
      function Remove(Element: T): Boolean; overload;
      function RemoveAll(Elements: TList<T>): Boolean;
      procedure RemoveAllSelection(Elements: TList<T>);
      procedure RemoveRange(const FromIndex, ToIndex: Integer);
      procedure RemoveFromSelection(Element: T);
      procedure RemoveListDataListener(Listener: IListDataListener);
      function SetElement(const Index: Integer; Element: T): T;
      procedure SetSelection(Elements: TList<T>);
      function SubList(const FromIndex, ToIndex: Integer): TList<T>;
   end;

implementation

{ TListModel<T> }

procedure TListModelList<T>.Add(const Index: Integer; Element: T);
begin

   FInnerList.Insert(Index, Element);

   NotifyDataChange;

end;

function TListModelList<T>.Add(Element: T): Boolean;
begin
   FInnerList.Add(Element);
end;

procedure TListModelList<T>.AddListDataListener(Listener: IListDataListener);
begin
   FListDataListener := Listener;
end;

function TListModelList<T>.AddToSelection(Element: T): Boolean;
begin

   if not FSelectionList.Contains(Element) then
      FSelectionList.Add(Element);

   NotifySelectionChange;

end;

procedure TListModelList<T>.Clear;
begin
   FInnerList := nil;
   FSelectionList.Clear;
end;

procedure TListModelList<T>.ClearSelection;
begin

   FSelectionList.Clear;

   NotifySelectionChange;

end;

function TListModelList<T>.Contains(Element: T): Boolean;
begin
   Result := FInnerList.Contains(Element);
end;

constructor TListModelList<T>.Create(Elements: TList<T>);
begin
   FInnerList := Elements;
end;

function TListModelList<T>.Get(const Index: Integer): T;
begin
   Result := FInnerList.Items[Index];
end;

function TListModelList<T>.GetElementAt(const Index: Integer): TObject;
begin
   Result := FInnerList.Items[Index] as TObject;
end;

function TListModelList<T>.GetInnerList: TList<T>;
begin
   Result := FInnerList;
end;

function TListModelList<T>.GetSelection: TList<T>;
begin
   Result := FSelectionList;
end;

function TListModelList<T>.GetSize: Integer;
begin
   Result := FInnerList.Count;
end;

function TListModelList<T>.IndexOf(Element: T): Integer;
begin
   Result := FInnerList.IndexOf(Element);
end;

function TListModelList<T>.IsEmpty: Boolean;
begin
   Result := FInnerList.Count = 0;
end;

function TListModelList<T>.IsSelectionEmpty: Boolean;
begin
   Result := FSelectionList.Count = 0;
end;

procedure TListModelList<T>.NotifyDataChange;
begin

   if Assigned(FListDataListener) then
      FListDataListener.OnDataChange;

end;

procedure TListModelList<T>.NotifySelectionChange;
var
   SelectedItems : TList<TObject>;
   Item : T;
begin

   if not Assigned(FListDataListener) then
      Exit;

   SelectedItems := TList<TObject>.Create;

   try

      for Item in FSelectionList do
         SelectedItems.Add(Item as TObject);

      FListDataListener.OnSelectionChange(SelectedItems);

   finally
      SelectedItems.Free;
   end;

end;

function TListModelList<T>.Remove(Element: T): Boolean;
begin

   Result := FInnerList.Remove(Element) <> -1;

   if Result then
   begin
      FSelectionList.Remove(Element);

      NotifyDataChange;
   end;

end;

function TListModelList<T>.Remove(const Index: Integer): T;
begin

   Result := FInnerList.Items[Index];

   if not Remove(Result) then
      Result := nil;

end;

function TListModelList<T>.RemoveAll(Elements: TList<T>): Boolean;
var
   Element : T;
begin

   for Element in Elements do
   begin
      Result := Result or (FInnerList.Remove(Element) <> -1);
      FSelectionList.Remove(Element);
   end;

   if Result then
      NotifyDataChange;

end;

procedure TListModelList<T>.RemoveAllSelection(Elements: TList<T>);
var
   Element : T;
   Notify : Boolean;
begin

   Notify := False;

   for Element in Elements do
      Notify := Notify or (FSelectionList.Remove(Element) <> -1);

   if Notify then
      NotifySelectionChange;

end;

procedure TListModelList<T>.RemoveFromSelection(Element: T);
begin

   if FSelectionList.Remove(Element) <> -1 then
      NotifySelectionChange;

end;

procedure TListModelList<T>.RemoveListDataListener(Listener: IListDataListener);
begin
   FListDataListener := nil;
end;

procedure TListModelList<T>.RemoveRange(const FromIndex, ToIndex: Integer);
begin

end;

function TListModelList<T>.SetElement(const Index: Integer; Element: T): T;
begin

end;

procedure TListModelList<T>.SetSelection(Elements: TList<T>);
var
   Element : T;
   Notify : Boolean;
begin

   Notify := False;

   for Element in Elements do
      Notify := Notify or AddToSelection(Element);

   if Notify then
      NotifySelectionChange;

end;

function TListModelList<T>.SubList(const FromIndex, ToIndex: Integer): TList<T>;
begin

end;

end.
