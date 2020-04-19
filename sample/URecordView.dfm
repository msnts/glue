object RecordView: TRecordView
  Left = 0
  Top = 0
  Caption = 'RecordView'
  ClientHeight = 627
  ClientWidth = 979
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbFirstName: TLabel
    Left = 16
    Top = 29
    Width = 51
    Height = 13
    Caption = 'Fist Name:'
  end
  object lbLastName: TLabel
    Left = 16
    Top = 56
    Width = 54
    Height = 13
    Caption = 'Last Name:'
  end
  object lbGender: TLabel
    Left = 16
    Top = 83
    Width = 39
    Height = 13
    Caption = 'Gender:'
  end
  object Label4: TLabel
    Left = 16
    Top = 112
    Width = 39
    Height = 13
    Caption = 'Gender:'
  end
  object Label5: TLabel
    Left = 16
    Top = 137
    Width = 29
    Height = 13
    Caption = 'Stars:'
  end
  object edtFistName: TEdit
    Left = 76
    Top = 26
    Width = 200
    Height = 21
    TabOrder = 0
  end
  object edtLastName: TEdit
    Left = 76
    Top = 53
    Width = 200
    Height = 21
    TabOrder = 1
  end
  object btn1: TButton
    Left = 430
    Top = 248
    Width = 91
    Height = 25
    Caption = 'Reset Fields'
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 76
    Top = 134
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object CheckBox1: TCheckBox
    Left = 79
    Top = 170
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 4
  end
  object cmbGender: TComboBox
    Left = 76
    Top = 80
    Width = 100
    Height = 21
    Style = csDropDownList
    TabOrder = 5
  end
  object ListBox1: TListBox
    Left = 320
    Top = 26
    Width = 145
    Height = 113
    ItemHeight = 13
    TabOrder = 6
  end
  object RadioButton1: TRadioButton
    Left = 336
    Top = 193
    Width = 113
    Height = 17
    Caption = 'RadioButton1'
    TabOrder = 7
  end
  object grp1: TGroupBox
    Left = 8
    Top = 193
    Width = 268
    Height = 105
    Caption = 'Option:'
    TabOrder = 8
    object RadioButton2: TRadioButton
      Left = 24
      Top = 32
      Width = 113
      Height = 17
      Caption = 'RadioButton2'
      TabOrder = 0
    end
    object RadioButton3: TRadioButton
      Left = 24
      Top = 55
      Width = 113
      Height = 17
      Caption = 'RadioButton3'
      TabOrder = 1
    end
  end
  object dtpDate: TDateTimePicker
    Left = 76
    Top = 107
    Width = 186
    Height = 21
    Date = 42896.000000000000000000
    Time = 0.690115127319586500
    TabOrder = 9
  end
  object Memo1: TMemo
    Left = 8
    Top = 304
    Width = 963
    Height = 195
    Lines.Strings = (
      'Memo1')
    TabOrder = 10
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 608
    Width = 979
    Height = 19
    Panels = <
      item
        Text = 'Status:'
        Width = 50
      end
      item
        Width = 50
      end>
  end
end
