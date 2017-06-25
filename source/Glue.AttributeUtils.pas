{ ******************************************************************************
  Copyright 2017 Marcos Santos

  Contact: marcos.santos@outlook.com

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
  *****************************************************************************}

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
            Exit(Result);
         end;

      end;

   finally
      Context.Free;
   end;

   Exit(nil);

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
         Exit;
      end;

   end;

   Exit(nil);
end;

end.
