unit Glue.View.Vcl;

interface
uses
   Vcl.StdCtrls,
   Rtti,
   System.Generics.Collections,
   Glue.ViewModel.ListModel,
   Glue.ViewModel.ListDataListener,
   Glue.View.DataTemplate;

type

   TComboBox = class(Vcl.StdCtrls.TComboBox, IListDataListener)
   private
      FListModel : IListModel;
      FSelectedItem : TObject;
      FTemplate : string;
      FDataTemplate : IDataTemplate;

      procedure SetSelectionItem(Item : TObject);
      procedure SetListModel(List : IListModel);
      procedure AddItemModel(Item : TObject);
      procedure SetTemplate(const ATemplate : string);
      procedure RefreshData();
   public
      procedure OnSelectionChange(const Selection : TList<TObject>);
      procedure OnDataChange();

      property Data : IListModel read FListModel write SetListModel;
      property SelectedItem : TObject read FSelectedItem write SetSelectionItem;
      property Template : string read FTemplate write SetTemplate;
   end;

   TListBox = class(Vcl.StdCtrls.TListBox)
   private
      FCollection : IListModel;
      FSelectedItem : TObject;

      procedure SetSelectionItem(Item : TObject);
   public
      property Data : IListModel read FCollection write FCollection;
      property SelectedItem : TObject read FSelectedItem write SetSelectionItem;
   end;

implementation

{ TListBox }

procedure TListBox.SetSelectionItem(Item: TObject);
begin

end;

{ TComboBox }

procedure TComboBox.AddItemModel(Item: TObject);
var
   Text : string;
begin

   Text := FDataTemplate.Evaluate(Item);

   Items.AddObject(Text, Item);

end;

procedure TComboBox.OnDataChange();
begin
   RefreshData;
end;

procedure TComboBox.OnSelectionChange(const Selection: TList<TObject>);
begin

   if Selection.Count = 0 then
      Exit;

   SetSelectionItem(Selection.Items[0]);

end;

procedure TComboBox.RefreshData;
var
   I, ListSize : Integer;
begin

   Items.Clear;

   ItemIndex := -1;

   ListSize := FListModel.GetSize;

   for I := 0 to ListSize - 1 do
      AddItemModel(FListModel.GetElementAt(I));

end;

procedure TComboBox.SetListModel(List: IListModel);
begin

   FListModel := List;

   FListModel.AddListDataListener(Self);

   RefreshData;

end;

procedure TComboBox.SetSelectionItem(Item: TObject);
begin
   ItemIndex := Items.IndexOfObject(Item);
end;

procedure TComboBox.SetTemplate(const ATemplate: string);
begin

   FTemplate := ATemplate;

   FDataTemplate := TDataTemplate.Create(ATemplate);

end;

end.
