object RecordManagerView: TRecordManagerView
  Left = 0
  Top = 0
  Caption = 'RecordManagerView'
  ClientHeight = 415
  ClientWidth = 890
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 874
    Height = 353
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object Button1: TButton
    Left = 8
    Top = 383
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 1
  end
  object Button2: TButton
    Left = 89
    Top = 383
    Width = 75
    Height = 25
    Caption = 'Edit'
    TabOrder = 2
  end
  object Button3: TButton
    Left = 170
    Top = 383
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 3
  end
  object DataSource1: TDataSource
    Left = 448
    Top = 128
  end
end
