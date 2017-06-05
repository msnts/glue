unit Glue.NotifyPropertyChanging;

interface

uses Glue.Observer;

type

   INotifyPropertyChanging = interface
      ['{6A9B8084-1A0B-4843-9070-9D5CC96AA9CA}']
      procedure Attach(Observer: IObserver);
      procedure Detach(Observer: IObserver);
      procedure Notify(const PropertyName: string); overload;
      procedure Notify(const PropertiesNames : TArray<string>); overload;
   end;

implementation

end.
