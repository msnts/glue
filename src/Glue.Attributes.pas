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
  System.SysUtils,
  System.RegularExpressions,
  Glue.Binding.BindingContext,
  Glue.Exceptions;

type

  TBindingMode = (mbSaveLoad, mbSave, mbLoad);

  TTriggerMode = (tmOnChange, tmOnExit);

  TGlueAttribute = class(TCustomAttribute);

  TBindBaseAttribute = class(TGlueAttribute)
  private
    FBindingMode : TBindingMode;
    FSourcePropertyName: string;
    FTargetPropertyName: string;
  public
    constructor Create(const ATargetPropertyName, ASourcePropertyName : string); virtual;
    property BindingMode: TBindingMode read FBindingMode;
    property SourcePropertyName: string read FSourcePropertyName;
    property TargetPropertyName: string read FTargetPropertyName;
  end;

  BindAttribute = class(TBindBaseAttribute)
  private
    FTriggerMode: TTriggerMode;
  public
    constructor Create(const ATargetPropertyName, ASourcePropertyName : string; ATriggerMode : TTriggerMode = tmOnChange); overload;
    property TriggerMode : TTriggerMode read FTriggerMode;
  end;

  LoadAttribute = class(TBindBaseAttribute)
  public
    constructor Create(const ATargetPropertyName, ASourcePropertyName : string); override;
  end;

  SaveAttribute = class(BindAttribute)
  public
    constructor Create(const ATargetPropertyName, ASourcePropertyName : string); override;
  end;

  CommandAttribute = class(TGlueAttribute)
  private
    FTriggerName : string;
    FHandlerName : string;
  public
    constructor Create(const HandlerName : string); overload;
    constructor Create(const TriggerName, HandlerName : string); overload;
    property TriggerName : string read FTriggerName;
    property HandlerName : string read FHandlerName;
  end;

  NotifyChangeAttribute = class(TGlueAttribute)
  private
    FPropertiesNames : TArray<string>;
  public
    constructor Create(const PropertyName : string); overload;
    property PropertiesNames : TArray<string> read FPropertiesNames;
  end;

  InitAttribute = class(TGlueAttribute);

  ViewModelAttribute = class(TGlueAttribute)
  private
    FQualifier : string;
  public
    constructor Create(const Qualifier : string);
    property Qualifier : string read FQualifier;
  end;

  ConverterAttribute = class(TGlueAttribute)
  private
    FQualifier : string;
  public
    constructor Create(const Qualifier : string);
    property Qualifier : string read FQualifier;
  end;

  TemplateAttribute = class(TGlueAttribute)
  private
    FExpression : string;
  public
    constructor Create(const AExpression : string);
    property Expression : string read FExpression;
  end;

  WireVariable = class(TGlueAttribute)
  private
    FQualifier: string;
  private
    constructor Create(const AQualifier: string);
    property Qualifier : string read FQualifier;
  end;

implementation

{ ViewModelAttribute }

constructor ViewModelAttribute.Create(const Qualifier: string);
begin
  if Qualifier.Trim.IsEmpty then
    raise EInvalidQualifierException.Create('Qualifier required');

  FQualifier := Qualifier.Trim;
end;

{ TBindBaseAttribute }

constructor TBindBaseAttribute.Create(const ATargetPropertyName, ASourcePropertyName : string);
begin
  FBindingMode := mbSaveLoad;
  FTargetPropertyName := ATargetPropertyName;
  FSourcePropertyName := ASourcePropertyName;
end;

{ ConverterAttribute }

constructor ConverterAttribute.Create(const Qualifier : string);
begin
  FQualifier := Qualifier;
end;

{ LoadAttribute }

constructor LoadAttribute.Create(const ATargetPropertyName, ASourcePropertyName : string);
begin
  inherited;
  FBindingMode := mbLoad;
end;

{ SaveAttribute }

constructor SaveAttribute.Create(const ATargetPropertyName, ASourcePropertyName : string);
begin
  inherited;
  FBindingMode := mbSave;
end;

{ CommandAttribute }

constructor CommandAttribute.Create(const HandlerName: string);
begin
  FTriggerName := 'OnClick';
  FHandlerName := HandlerName;
end;

constructor CommandAttribute.Create(const TriggerName, HandlerName: string);
begin
  FTriggerName := TriggerName;
  FHandlerName := HandlerName;
end;

{ NotifyChange }

constructor NotifyChangeAttribute.Create(const PropertyName: string);
begin
  FPropertiesNames := PropertyName.Replace(' ', '').Split([',']);
end;

{ TemplateAttribute }

constructor TemplateAttribute.Create(const AExpression: string);
begin
  FExpression := AExpression;
end;

{ BindAttribute }

constructor BindAttribute.Create(const ATargetPropertyName, ASourcePropertyName: string; ATriggerMode: TTriggerMode);
begin
  inherited Create(ATargetPropertyName, ASourcePropertyName);
  FTriggerMode := ATriggerMode;
end;

{ WireVariable }

constructor WireVariable.Create(const AQualifier: string);
begin
  FQualifier := AQualifier;
end;

end.
