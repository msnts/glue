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
unit Glue.Core.Impl.DialogService;

interface
uses
  Vcl.Dialogs,
  Glue.Core.DialogService;

type
  TDialogService = class(TInterfacedObject, IDialogService)
  public
    procedure ShowMessage(const AMessage: string);
  end;

implementation

{ TDialogService }

procedure TDialogService.ShowMessage(const AMessage: string);
begin
  Vcl.Dialogs.ShowMessage(AMessage);
end;

end.
