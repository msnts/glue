unit Glue.Binding;

interface
uses
   System.Classes,
   Glue.NotifyPropertyChanging;

type

   TModeBinding = (mbSaveLoad, mbSave, mbLoad);

   IBinding = interface
      ['{C42BE6E7-C328-4ABC-8EF9-FD1A1D2F5E25}']
      procedure UpdateView();
      procedure AddListenerBefore(Listener : IBinding);
      procedure AddListenerAfter(Listener : IBinding);
      procedure SetComponent(Component : TComponent);
      procedure SetViewModel(ViewModel : INotifyPropertyChanging);
      procedure ProcessBinding();
   end;

implementation

end.
