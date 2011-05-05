{*******************************************************************************
Title: T2Ti ERP
Description: Pesquisa por produto e importação para a venda.

The MIT License

Copyright: Copyright (C) 2010 T2Ti.COM

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

       The author may be contacted at:
           t2ti.com@gmail.com</p>

@author Albert Eije (T2Ti.COM)
@version 1.0
*******************************************************************************}
unit UImportaProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, JvExDBGrids, JvDBGrid, StdCtrls, JvExStdCtrls,
  JvButton, JvCtrls, Buttons, JvExButtons, JvBitBtn, pngimage, ExtCtrls, Mask,
  JvEdit, JvValidateEdit, JvDBSearchEdit, DB, Provider, DBClient, FMTBcd,
  SqlExpr, Biblioteca, JvExControls, JvEnterTab, JvComponentBase;

type
  TFImportaProduto = class(TForm)
    botaoConfirma: TJvBitBtn;
    botaoCancela: TJvImgBtn;
    QProduto: TSQLQuery;
    DSProduto: TDataSource;
    CDSProduto: TClientDataSet;
    DSPProduto: TDataSetProvider;
    Label2: TLabel;
    CDSProdutoID: TIntegerField;
    CDSProdutoID_UNIDADE_PRODUTO: TIntegerField;
    CDSProdutoGTIN: TStringField;
    CDSProdutoCODIGO_INTERNO: TStringField;
    CDSProdutoNOME: TStringField;
    CDSProdutoDESCRICAO: TMemoField;
    CDSProdutoDESCRICAO_PDV: TStringField;
    CDSProdutoVALOR_VENDA: TFMTBCDField;
    CDSProdutoQTD_ESTOQUE: TFMTBCDField;
    CDSProdutoESTOQUE_MIN: TFMTBCDField;
    CDSProdutoESTOQUE_MAX: TFMTBCDField;
    CDSProdutoIAT: TStringField;
    CDSProdutoIPPT: TStringField;
    CDSProdutoNCM: TStringField;
    GroupBox3: TGroupBox;
    Image1: TImage;
    EditLocaliza: TEdit;
    GroupBox6: TGroupBox;
    GridPrincipal: TJvDBGrid;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure localiza;
    procedure confirma;
    procedure FormActivate(Sender: TObject);
    procedure GridPrincipalKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure botaoConfirmaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditLocalizaChange(Sender: TObject);
    procedure EditLocalizaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditLocalizaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridPrincipalDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FImportaProduto: TFImportaProduto;
  QuemChamou: String;
  coluna: String;

implementation

uses UDataModule, ConexaoBD, UDAV, UPreVenda;

{$R *.dfm}

procedure TFImportaProduto.botaoConfirmaClick(Sender: TObject);
begin
  confirma;
end;

procedure TFImportaProduto.confirma;
begin
 if QuemChamou = 'DAV' then
  begin
  if CDSProduto.FieldByName('VALOR_VENDA').AsFloat > 0 then
  begin

    if (FDAV.StatusDAV = 0) or (FDAV.StatusDAV = 1) then
    begin
      FDAV.editCodigo.Text := CDSProduto.FieldByName('ID').AsString;

    end;
    close;
  end
  else
    Application.MessageBox('Produto não pode ser vendido com valor zerado ou negativo.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION);

  end;


  if QuemChamou = 'PV' then
  begin
  if CDSProduto.FieldByName('VALOR_VENDA').AsFloat > 0 then
  begin
    if (FPreVenda.StatusPreVenda = 1) or (FPreVenda.StatusPreVenda = 2) then
    begin

      FPreVenda.editCodigo.Text := CDSProduto.FieldByName('ID').AsString;
    end;
    close;
  end
  else
    Application.MessageBox('Produto não pode ser vendido com valor zerado ou negativo.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TFImportaProduto.EditLocalizaChange(Sender: TObject);
begin
  localiza;
end;

procedure TFImportaProduto.EditLocalizaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DOWN then
   GridPrincipal.SetFocus;
  if Key = VK_UP then
    Perform(WM_NEXTDLGCTL, 1, 0);
  if Key = VK_ESCAPE then
      Close;
  if Key = 13 then
      confirma;
end;

procedure TFImportaProduto.EditLocalizaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 // F2 Chama procedure Localiza
  if Key = 113 then
    localiza;
end;

procedure TFImportaProduto.FormActivate(Sender: TObject);
begin
  EditLocaliza.SetFocus;  
end;

procedure TFImportaProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFImportaProduto.FormCreate(Sender: TObject);
begin
    QProduto.SQLConnection := FDataModule.Conexao;
end;

procedure TFImportaProduto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // F2 - Localiza
  if Key = 113 then
    localiza;
  // F12 - Confirma
  if Key = 123 then
    confirma;
  // ESC - Sair
  if Key = VK_ESCAPE then
      Close;
  // F1 - Vai para o Edit Localiza
  if Key = VK_F1 then
      EditLocaliza.SetFocus;

end;

procedure TFImportaProduto.GridPrincipalDblClick(Sender: TObject);
begin
  confirma;
end;

procedure TFImportaProduto.GridPrincipalKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Enter seleciona o fbn e lança no no formulario de espera
  if Key = 123 then
    confirma;
  if Key = 13 then
    confirma;
    // ESC Sair
  if Key = VK_ESCAPE then
      Close;
end;

procedure TFImportaProduto.localiza;
var
  ProcurePor: String;
begin
  ProcurePor := EditLocaliza.Text + '%';
  CDSProduto.Active := False;
  QProduto.Active := False;
  QProduto.SQL.Clear;
  QProduto.SQL.Text:= 'SELECT * FROM PRODUTO WHERE NOME LIKE ' + QuotedStr(ProcurePor) + ' ORDER BY NOME';
  QProduto.Open;
  CDSProduto.Active := True;
  //Label2.Caption := FloatToStrF(QProduto.RecordCount, ffNumber,15,0) + ' produtos localizados.';
end;

end.
