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
   Glue.Attributes,
   Glue.AttributeUtils,
   Vcl.Forms,
   System.Classes,
   System.Rtti;

type

   TExecutions = class
   public
      class procedure ShowWindow(const QualifiedClassName: String); overload;
      class procedure ShowWindow(const QualifiedClassName: String; Event : TObject); overload;
   end;

implementation

{ TExecutions }

class procedure TExecutions.ShowWindow(const QualifiedClassName: String);
begin
   ShowWindow(QualifiedClassName, nil);
end;

class procedure TExecutions.ShowWindow(const QualifiedClassName: String;
  Event: TObject);
var
   Window : TForm;
   DataMananger : IDataManager;
   ViewModel : TObject;
   Attribute : ViewModelAttribute;
   Glue : TGlue;
begin

   Glue := TGlue.GetInstance;

   try

      Window := Glue.Resolve(QualifiedClassName) as TForm;

      Attribute := TAttributeUtils.GetAttribute<ViewModelAttribute>(Window.ClassType);

      ViewModel := Glue.Resolve(Attribute.QualifiedClassName);

      DataMananger := TDataManager.Create(Window, ViewModel);

      if Event <> nil then
         Glue.PostEvent(Event);

      Window.ShowModal;

   finally
      DataMananger.ReleaseData;

      if not Glue.HasDependencyResolver then
      begin
         ViewModel.Free;
         Window.Free;
      end;
   end;

end;

end.
