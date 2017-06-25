unit Glue.AttributeUtils;

interface
uses System.Rtti;

type

   TAttributeUtils = class
   public
      class function GetAttribute<T : TCustomAttribute>(ClassType : TClass) : T; overload;
      class function GetAttribute<T : TCustomAttribute>(Method : TRttiMethod) : T; overload;
   end;

implementation

{ TAttributeUtils }

class function TAttributeUtils.GetAttribute<T>(ClassType: TClass): T;
var
   Context: TRttiContext;
   typ: TRttiType;
   Attribute: TCustomAttribute;
begin

   Context := TRttiContext.Create;

   try

      typ := Context.GetType(ClassType);

      for Attribute in typ.GetAttributes do
      begin

         if Attribute is T then
         begin
            Result := Attribute as T;
            Break;
         end;

      end;

   finally
      Context.Free;
   end;

end;

class function TAttributeUtils.GetAttribute<T>(Method: TRttiMethod): T;
var
   Attribute: TCustomAttribute;
begin

   for Attribute in Method.GetAttributes do
   begin

      if Attribute is T then
      begin
         Result := Attribute as T;
         Break;
      end;

   end;

end;

end.
