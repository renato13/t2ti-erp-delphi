object FDataModule: TFDataModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 253
  Width = 247
  object Conexao: TSQLConnection
    KeepConnection = False
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object CDSDAV: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforePost = CDSDAVBeforePost
    Left = 40
    Top = 80
  end
  object DSDAV: TDataSource
    DataSet = CDSDAV
    Left = 40
    Top = 136
  end
  object CDSPV: TClientDataSet
    Aggregates = <>
    Params = <>
    BeforePost = CDSPVBeforePost
    Left = 144
    Top = 80
  end
  object DSPV: TDataSource
    DataSet = CDSPV
    Left = 144
    Top = 136
  end
end
