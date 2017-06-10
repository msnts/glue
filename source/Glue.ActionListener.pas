unit Glue.ActionListener;

interface

type

   IActionListener = interface
      ['{2CB9ED17-6729-44A3-BB17-B1CC96FC6788}']
      procedure OnBefore(CommandName : String);
      procedure OnAfter(CommandName : String);
   end;

implementation

end.
