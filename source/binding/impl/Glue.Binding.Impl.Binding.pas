unit Glue.Binding.Impl.Binding;

interface

uses
   System.Classes,
   Vcl.StdCtrls,
   System.SysUtils,
   Rtti,
   Glue.Attributes,
   Glue.Binding,
   Generics.Collections,
   Glue.Binding.BindingContext,
   Glue.Converter,
   Glue.Converter.Impl.GenericConverter,
   Glue.Exceptions;

type

   TBinding = class(TInterfacedObject, IBinding)
   protected
      FComponent: TComponent;
      FViewModel: TObject;
      FMode: TModeBinding;
      FBindContext: TBindContext;
      FRTTIContext: TRttiContext;
      FPropertyVM: TRttiProperty;
      FPropertyUI: TRttiProperty;
      FComponentType: TRttiType;
      FViewModelType: TRttiType;
      FConverter : IConverter;
   protected
      procedure OnChange(Sender: TObject);
      procedure ProcessBinding();
   public
      constructor Create(Mode: TModeBinding; Component: TComponent; ViewModel: TObject; Converter : IConverter; Context: TBindContext);
      procedure LoadData();
      procedure SaveData();
   end;

implementation

{ TBinding }

constructor TBinding.Create(Mode: TModeBinding; Component: TComponent; ViewModel: TObject; Converter : IConverter; Context: TBindContext);
begin

   FMode := Mode;

   FComponent := Component;

   FViewModel := ViewModel;

   FBindContext := Context;

   FRTTIContext := TRttiContext.Create;

   ProcessBinding;

   FConverter := Converter;

   if FConverter is TGenericConverter then
      TGenericConverter(FConverter).SetPropertiesType(FPropertyUI.PropertyType, FPropertyVM.PropertyType);

end;

procedure TBinding.OnChange(Sender: TObject);
var
   Value: TValue;
begin

   Value := FConverter.coerceToVM(FPropertyUI.GetValue(TEdit(FComponent)), FComponent);

   FPropertyVM.SetValue(FViewModel as TObject, Value);

end;

procedure TBinding.ProcessBinding;
var
   objType: TRttiType;
   Prop: TRttiProperty;
begin

   objType := FRTTIContext.GetType(TObject(FViewModel).ClassType);

   FPropertyVM := objType.GetProperty(FBindContext.AttributeVM);

   if (FMode <> mbLoad) and not FPropertyVM.IsWritable then
      raise EInvalidDataBindingException.Create('Error Data Binding: The "' + FBindContext.AttributeVM + '" Property of the ViewModel is read-only');

   objType := FRTTIContext.GetType(FComponent.ClassType);

   FPropertyUI := objType.GetProperty(FBindContext.AttributeUI);

   if (FMode = mbLoad) and not FPropertyUI.IsWritable then
      raise EInvalidDataBindingException.Create('Error Data Binding: The "' + FBindContext.AttributeUI + '" Property of the View is read-only');

   if FMode = mbLoad then
      Exit;

   Prop := objType.GetProperty('OnChange');

   if Prop = nil then
      Prop := objType.GetProperty('OnClick');

   if Prop = nil then
      raise Exception.Create('Property OnChange not found');

   Prop.SetValue(FComponent, TValue.From<TNotifyEvent>(OnChange));

end;

procedure TBinding.SaveData;
begin

end;

procedure TBinding.LoadData;
var
   Value: TValue;
begin

   if FMode = mbSave then
      Exit;

   Value := FConverter.coerceToUI(FPropertyVM.GetValue(FViewModel as TObject), FComponent);

   FPropertyUI.SetValue(FComponent, Value);

end;

end.
