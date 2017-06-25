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

unit Glue.BindableBase;

interface
uses
   Glue.Observer,
   Glue.NotifyPropertyChanging;

type

   TBindableBase = class(TInterfacedObject, INotifyPropertyChanging)
   private
      FObserver : IObserver;
   public
      procedure Attach(Observer: IObserver);
      procedure Detach(Observer: IObserver);
      procedure Notify(const PropertyName: string); overload;
      procedure Notify(const PropertiesNames : TArray<string>); overload;
   end;

implementation

{ TBindableBase }

procedure TBindableBase.Attach(Observer: IObserver);
begin
   FObserver := Observer;
end;

procedure TBindableBase.Detach(Observer: IObserver);
begin
   FObserver := nil;
end;

procedure TBindableBase.Notify(const PropertiesNames: TArray<string>);
var
   PropertyName : string;
begin

   for PropertyName in PropertiesNames do
      Notify(PropertyName);

end;

procedure TBindableBase.Notify(const PropertyName: string);
begin
   IObserver(FObserver).Update(PropertyName);
end;

end.
