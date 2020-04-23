{ ******************************************************************************
  Copyright 2020 Marcos Santos

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
unit Glue.Core.Impl.BinderStore;

interface
uses
  Generics.Collections,
  Glue.Binding,
  Glue.Core.BinderStore;

type
  TBinderStore = class(TInterfacedObject, IBinderStore)
  private
    FBinders: TDictionary<string, TList<IBinding>>;
  public
    constructor Create();
    destructor Destroy(); override;
    procedure Add(const AKey: string; ABind: IBinding);
    function ContainsKey(const AKey: string): Boolean;
    function GetItems(const AKey: string): TList<IBinding>;
    function GetValues(): TArray<TList<IBinding>>;
  end;

implementation

{ TBinderStore }

procedure TBinderStore.Add(const AKey: string; ABind: IBinding);
begin
  if not FBinders.ContainsKey(AKey) then
    FBinders.Add(AKey, TList<IBinding>.Create());

  FBinders.Items[AKey].Add(ABind);
end;

function TBinderStore.ContainsKey(const AKey: string): Boolean;
begin
  Result := FBinders.ContainsKey(AKey);
end;

constructor TBinderStore.Create;
begin
  FBinders := TDictionary<string, TList<IBinding>>.Create();
end;

destructor TBinderStore.Destroy;
var
  LItems: TList<IBinding>;
begin
  for LItems in FBinders.Values.ToArray do
    LItems.Free;

  FBinders.Free;
  inherited;
end;

function TBinderStore.GetItems(const AKey: string): TList<IBinding>;
begin
  Result := FBinders.Items[AKey];
end;

function TBinderStore.GetValues: TArray<TList<IBinding>>;
begin
  Result := FBinders.Values.ToArray;
end;

end.
