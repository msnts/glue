unit Glue.BindableBase;

interface
uses
   Glue.Observer,
   Glue.NotifyPropertyChanging;

type

   TBindableBase = class(TInterfacedObject, INotifyPropertyChanging)
   private
      FObserver : IObserver;
   public
      procedure Attach(Observer: IObserver);
      procedure Detach(Observer: IObserver);
      procedure Notify(const PropertyName: string); overload;
      procedure Notify(const PropertiesNames : TArray<string>); overload;
   end;

implementation

{ TBindableBase }

procedure TBindableBase.Attach(Observer: IObserver);
begin
   FObserver := Observer;
end;

procedure TBindableBase.Detach(Observer: IObserver);
begin
   FObserver := nil;
end;

procedure TBindableBase.Notify(const PropertiesNames: TArray<string>);
var
   PropertyName : string;
begin

   for PropertyName in PropertiesNames do
      Notify(PropertyName);

end;

procedure TBindableBase.Notify(const PropertyName: string);
begin
   IObserver(FObserver).Update(PropertyName);
end;

end.
