unit Glue.Binding;

interface

type

   TModeBinding = (mbSaveLoad, mbSave, mbLoad);

   IBinding = interface
      ['{C42BE6E7-C328-4ABC-8EF9-FD1A1D2F5E25}']
      procedure UpdateView();
      procedure AddListenerBefore(Listener : IBinding);
      procedure AddListenerAfter(Listener : IBinding);
   end;

implementation

end.
