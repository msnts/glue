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

unit Glue.Executions;

interface
uses
   Glue,
   Glue.DataManager,
   Vcl.Forms;

type

   TExecutions = class
   public
      class function CreateView<T>(QualifiedClassName: String) : T;
      class function CreateViewModel<T>(QualifiedClassName: String) : T;
      class procedure ShowWindows(QualifiedClassName: String);
   end;

implementation

{ TExecutions }

class function TExecutions.CreateView<T>(QualifiedClassName: String): T;
begin

end;

class function TExecutions.CreateViewModel<T>(QualifiedClassName: String): T;
begin

end;

class procedure TExecutions.ShowWindows(QualifiedClassName: String);
var
   Windows : TForm;
   DataMananger : IDataManager;
   ViewModel : TObject;
begin

   try

      Windows := CreateView<TForm>(QualifiedClassName);

     // ViewModel := CreateViewModel<TObject>();

      DataMananger := TDataManager.Create(Windows, ViewModel);

      Windows.ShowModal;

   finally
      DataMananger.ReleaseData;
      Windows.Free;
   end;

end;

end.
