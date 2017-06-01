unit Glue.Observer;

interface

type

   IObserver = interface
      ['{CE3C8BB1-00DE-4ED1-ADD8-00CBD2BE1E80}']
      procedure Update(const PropertyName: string);
   end;

implementation

end.
