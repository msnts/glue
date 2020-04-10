unit Glue.Binding.Command;

interface
uses Glue.ActionListener;

type
   ICommand = interface
      ['{D0C33C63-B1D3-4B55-AF7E-36DF2CAEDD1C}']
      procedure Attach(Listener: IActionListener);
      procedure Detach(Listener: IActionListener);
   end;

implementation

end.
