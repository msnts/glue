unit Glue.ActionListener;

interface

type

   IActionListener = interface
      ['{2CB9ED17-6729-44A3-BB17-B1CC96FC6788}']
      procedure OnBeforeAction(ActionName : String);
      procedure OnAfterAction(ActionName : String);
   end;

implementation

end.
