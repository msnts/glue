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

unit Glue.Attributes;

interface
uses
   System.RegularExpressions,
   Glue.Binding.BindingContext,
   Glue.Enum;

type

   TBindBaseAttribute = class(TCustomAttribute)
   private
      FBindContext : TBindContext;
      FMode : TModeBinding;
   public
      constructor Create(Expression : String); virtual;
      property BindContext : TBindContext read FBindContext;
      property Mode : TModeBinding read FMode;
   end;

   BindAttribute = class(TBindBaseAttribute);

   LoadAttribute = class(TBindBaseAttribute)
   public
      constructor Create(Expression : String); override;
   end;

   SaveAttribute = class(TBindBaseAttribute)
   public
      constructor Create(Expression : String); override;
   end;

   CommandAttribute = class(TCustomAttribute)
   private
      FTriggerName : String;
      FHandlerName : String;
   public
      constructor Create(const HandlerName : String); overload;
      constructor Create(const TriggerName, HandlerName : String); overload;
      property TriggerName : String read FTriggerName;
      property HandlerName : String read FHandlerName;
   end;

   NotifyChange = class(TCustomAttribute)
   private
      FPropertiesNames : TArray<string>;
   public
      constructor Create(const PropertyName : String); overload;
      property PropertiesNames : TArray<string> read FPropertiesNames;
   end;

   ViewModelAttribute = class(TCustomAttribute)
   private
      FQualifiedClassName : String;
   public
      constructor Create(const QualifiedClassName : String);
      property QualifiedClassName : String read FQualifiedClassName;
   end;

   ConverterAttribute = class(TCustomAttribute)
   private
      FClassName : String;
   public
      constructor Create(ClassName : String);
      property ClassName : String read FClassName;
   end;

implementation
uses System.SysUtils;

{ ViewModelAttribute }

constructor ViewModelAttribute.Create(const QualifiedClassName: String);
begin

   if QualifiedClassName.Trim.IsEmpty then
      raise Exception.Create('Class Name required');

   FQualifiedClassName := QualifiedClassName;
end;

{ TBindBaseAttribute }

constructor TBindBaseAttribute.Create(Expression: String);
var
   RegularExpression: TRegEx;
   Match: TMatch;
begin

   FMode := mbSaveLoad;

   RegularExpression.Create
     ('(\btarget=(\w+))|(\bsource=(\w+))|(\bif=(.[^;]+);?)|(\bbefore=([\w\.,]+))|(\bafter=([\w\.,]+))|(\bconverter=([\w\.]+))');
   Match := RegularExpression.Match(Expression);

   if Match.Success then
   begin
      FBindContext.AttributeUI := Match.Groups.Item[2].Value;

      Match := Match.NextMatch;

      if Match.Success then
         FBindContext.AttributeVM := Match.Groups.Item[4].Value;

      Match := Match.NextMatch;

      if Match.Success then
         FBindContext.Condition := Match.Groups.Item[6].Value;

      Match := Match.NextMatch;

      if Match.Success then
         FBindContext.Condition := Match.Groups.Item[8].Value;

      Match := Match.NextMatch;

      if Match.Success then
         FBindContext.After := Match.Groups.Item[10].Value;

   end;

end;

{ ConverterAttribute }

constructor ConverterAttribute.Create(ClassName: String);
begin
   FClassName := ClassName;
end;

{ LoadAttribute }

constructor LoadAttribute.Create(Expression: String);
begin
  inherited;
  FMode := mbLoad;
end;

{ SaveAttribute }

constructor SaveAttribute.Create(Expression: String);
begin
  inherited;
  FMode := mbSave;
end;

{ CommandAttribute }

constructor CommandAttribute.Create(const HandlerName: String);
begin
   FTriggerName := 'OnClick';
   FHandlerName := HandlerName;
end;

constructor CommandAttribute.Create(const TriggerName, HandlerName: String);
begin
   FTriggerName := TriggerName;
   FHandlerName := HandlerName;
end;

{ NotifyChange }

constructor NotifyChange.Create(const PropertyName: String);
begin
   FPropertiesNames := PropertyName.Replace(' ', '').Split([',']);
end;

end.
