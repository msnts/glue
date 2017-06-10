unit Glue.Binding;

interface
uses
   System.Classes,
   Glue.NotifyPropertyChanging;

type

   IBinding = interface
      ['{C42BE6E7-C328-4ABC-8EF9-FD1A1D2F5E25}']
      procedure UpdateView();
      //procedure Execute;
   end;

implementation

end.
