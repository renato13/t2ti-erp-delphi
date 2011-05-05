{*******************************************************************************
Title: T2Ti ERP
Description: Tela DAV do sistema de balcão do PAF-ECF.

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

@author Eri Brito
@version 1.0
*******************************************************************************}

unit UDAV;

interface

uses
  SysUtils, Types, Windows, Classes, Forms, ACBrBase,StdCtrls,
  Controls, ComCtrls, ExtCtrls, ACBrEnterTab, Mask, Graphics, Generics.Collections,
  JvExStdCtrls, Dialogs, JvEdit, JvValidateEdit, Buttons,
  JvButton, JvCtrls, JvExButtons, JvBitBtn, ACBrValidador, JvExMask,
  JvToolEdit, JvExControls, JvLabel, JvGradient, COMObj, Grids, DBGrids,
  JvExDBGrids, JvDBGrid, JvDBUltimGrid, DB,DAVController, DAVVO, DAVDetalheVO,
  ClienteController, ClienteVO, Messages, pngimage;

type
  TFDAV = class(TForm)
    ACBrEnterTab1: TACBrEnterTab;
    GroupBox1: TGroupBox;
    editCodigo: TEdit;
    editQuantidade: TJvValidateEdit;
    Label1: TLabel;
    Label2: TLabel;
    PanelBotoes: TPanel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    editCodigoCliente: TMaskEdit;
    GroupBox6: TGroupBox;
    GridItens: TJvDBUltimGrid;
    Label4: TLabel;
    editUnitario: TJvValidateEdit;
    EditNome: TLabeledEdit;
    lblTitulo: TLabel;
    editCpfCnpj: TLabeledEdit;
    GroupBox3: TGroupBox;
    labelDescricaoProduto: TJvLabel;
    GroupBox5: TGroupBox;
    Bevel4: TBevel;
    Bevel2: TBevel;
    Bevel1: TBevel;
    Label7: TLabel;
    lblSubTotal: TLabel;
    LabelDescontoAcrescimo: TLabel;
    Label6: TLabel;
    lblValorTotal: TLabel;
    editTotalItem: TJvValidateEdit;
    Label5: TLabel;
    Image1: TImage;
    panelF8: TPanel;
    labelF9: TLabel;
    imageF9: TImage;
    panelF11: TPanel;
    labelF11: TLabel;
    imageF11: TImage;
    panelF12: TPanel;
    labelF12: TLabel;
    imageF12: TImage;
    PanelEsc: TPanel;
    Label8: TLabel;
    Image2: TImage;
    panelF1: TPanel;
    labelF1: TLabel;
    imageF1: TImage;
    PanelF6: TPanel;
    LabelF6: TLabel;
    ImageF6: TImage;
    panelF10: TPanel;
    labelF10: TLabel;
    imageF10: TImage;
    lblDescAcrescDescricao: TLabel;
    Label9: TLabel;
    procedure Soma;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure editCodigoClienteKeyPress(Sender: TObject; var Key: Char);
    procedure editCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure editCodigoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure editCodigoEnter(Sender: TObject);
    procedure editCodigoExit(Sender: TObject);
    procedure panelF1Click(Sender: TObject);
    procedure panelF6Click(Sender: TObject);
    procedure panelF8Click(Sender: TObject);
    procedure panelF10Click(Sender: TObject);
    procedure panelF11Click(Sender: TObject);
    procedure panelF12Click(Sender: TObject);
    procedure PanelEscClick(Sender: TObject);
    procedure panelF1MouseEnter(Sender: TObject);
    procedure panelF1MouseLeave(Sender: TObject);
    procedure panelF6MouseEnter(Sender: TObject);
    procedure panelF6MouseLeave(Sender: TObject);
    procedure panelF8MouseEnter(Sender: TObject);
    procedure panelF8MouseLeave(Sender: TObject);
    procedure panelF10MouseEnter(Sender: TObject);
    procedure panelF10MouseLeave(Sender: TObject);
    procedure panelF11MouseEnter(Sender: TObject);
    procedure panelF11MouseLeave(Sender: TObject);
    procedure panelF12MouseEnter(Sender: TObject);
    procedure panelF12MouseLeave(Sender: TObject);
    procedure PanelEscMouseEnter(Sender: TObject);
    procedure PanelEscMouseLeave(Sender: TObject);
    procedure editCodigoClienteEnter(Sender: TObject);
    procedure editCodigoClienteExit(Sender: TObject);

  private
    { Private declarations }
    procedure ShowHint(Sender: TObject);
    procedure limpaCampos;
    procedure ConfiguraCDSGrid;
    procedure localizaClienteId;
    procedure localizaClienteCpfCnpj;
    procedure IdentificaCliente;
    procedure Confirma;
    procedure ImprimirDAV;
    procedure AtualizaTotais;
    procedure ConsultaProduto(Codigo: String);
    procedure ConsultaProdutoCodigoBalanca(CodigoBalanca: Integer);
    procedure ConsultaProdutoCodigoInterno(CodigoInterno: string);
    procedure ConsultaProdutoId(id: Integer);
    function DesmembraCodigoDigitado(
      var CodigoDeBarraOuDescricaoOuIdProduto: string; var Preco,
      Qtde: Extended): integer;
    procedure MensagemDeProdutoNaoEncontrado;
    procedure VendeItem;
    procedure LocalizaProduto;
    procedure IniciaVendaDeItens;
    procedure ExcluirItem;
    procedure DescontoOuAcrescimo;
    procedure TelaPadrao;

  public

  var
  StatusDav: Integer; // 0-Aberto | 1-Impresso
  PodeFinalizar: Integer; // 0-Pode finalizar |1-Não pode finalizar
  Cliente: TClienteVO;
  end;

var
  FDAV: TFDAV;
  SeqItem: Integer;
  SubTotal, TotalGeral, Desconto, Acrescimo: Extended;
  CodigoDAV: Integer;

implementation

uses UImportaProduto, UDataModule, UProcuraCliente , Biblioteca, ProdutoVO,
  ProdutoController, Constantes, ULoginGerenteSupervisor, UDescontoAcrescimo;

var
  DAVCabecalho : TDAVVO;
  Produto: TProdutoVO;

{$R *.dfm}


procedure TFDAV.ShowHint(Sender: TObject);
begin
    labelDescricaoProduto.Caption := Application.Hint;
end;

procedure TFDAV.Soma;
begin
  SubTotal := SubTotal + FDataModule.CDSDAV.FieldByName('VALOR_TOTAL').AsFloat;
  TotalGeral := SubTotal + (Acrescimo - Desconto);
end;

procedure TFDAV.ConfiguraCDSGrid;
begin
  // Configuramos o ClientDataSet do DAV Detalhe
  FDataModule.CDSDAV.Close;
  FDataModule.CDSDAV.FieldDefs.Clear;
  FDataModule.CDSDAV.FieldDefs.add('ITEM', ftInteger);
  FDataModule.CDSDAV.FieldDefs.add('GTIN', ftString, 20);
  FDataModule.CDSDAV.FieldDefs.add('DESCRICAO_PDV', ftString, 60);
  FDataModule.CDSDAV.FieldDefs.add('QUANTIDADE', ftFloat);
  FDataModule.CDSDAV.FieldDefs.add('VALOR_UNITARIO', ftFloat);
  FDataModule.CDSDAV.FieldDefs.add('VALOR_TOTAL', ftFloat);
  FDataModule.CDSDAV.FieldDefs.add('ID_PRODUTO', ftInteger);
  FDataModule.CDSDAV.FieldDefs.add('CANCELADO', ftString, 1);
  FDataModule.CDSDAV.CreateDataSet;
  TFloatField(FDataModule.CDSDAV.FieldByName('QUANTIDADE')).displayFormat:='#########0.00';
  TFloatField(FDataModule.CDSDAV.FieldByName('VALOR_UNITARIO')).displayFormat:='#########0.00';
  TFloatField(FDataModule.CDSDAV.FieldByName('VALOR_TOTAL')).displayFormat:='#########0.00';
  // Definimos os cabeçalhos da Grid Principal

  GridItens.Columns[0].Title.Caption := 'Item';
  GridItens.Columns[0].Title.Alignment := taCenter;
  GridItens.Columns[0].Width := 40;

  GridItens.Columns[1].Title.Caption := 'Produto GTIN';
  GridItens.Columns[1].Title.Alignment := taCenter;
  GridItens.Columns[1].Alignment := taLeftJustify;
  GridItens.Columns[1].Width := 110;

  GridItens.Columns[2].Title.Caption := 'Descrição';
  GridItens.Columns[2].Title.Alignment := taCenter;
  GridItens.Columns[2].Width := 300;

  GridItens.Columns[3].Title.Caption := 'Qtde';
  GridItens.Columns[3].Title.Alignment := taCenter;

  GridItens.Columns[4].Title.Caption := 'Unitário';
  GridItens.Columns[4].Title.Alignment := taCenter;
  GridItens.Columns[4].Alignment := taRightJustify;

  GridItens.Columns[5].Title.Caption := 'Total';
  GridItens.Columns[5].Title.Alignment := taCenter;
  GridItens.Columns[5].Alignment := taRightJustify;

  //Valores inacessíveis para alteração
  GridItens.Columns[0].ReadOnly := True;
  GridItens.Columns[1].ReadOnly := True;
  GridItens.Columns[2].ReadOnly := True;
  GridItens.Columns[3].ReadOnly := True;
  GridItens.Columns[4].ReadOnly := True;
  GridItens.Columns[5].ReadOnly := True;

  GridItens.Columns.Items[6].Visible := False;
  GridItens.Columns.Items[7].Visible := False;
end;

procedure TFDAV.editCodigoClienteEnter(Sender: TObject);
begin
    ACBrEnterTab1.EnterAsTab := False;
end;

procedure TFDAV.editCodigoClienteExit(Sender: TObject);
begin
    ACBrEnterTab1.EnterAsTab := True;
end;

procedure TFDAV.editCodigoClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    begin
      if trim(editCodigoCliente.Text) <> '' then
      begin
        if Length(editCodigoCliente.Text) <= 9 then
              localizaClienteId;
        if Length(editCodigoCliente.Text) > 9 then
              localizaClienteCpfCnpj;
      end;
    end;
end;

procedure TFDAV.editCodigoEnter(Sender: TObject);
begin
 ACBrEnterTab1.EnterAsTab := False;
end;

procedure TFDAV.editCodigoExit(Sender: TObject);
begin
  ACBrEnterTab1.EnterAsTab := True;
end;

procedure TFDAV.editCodigoKeyPress(Sender: TObject; var Key: Char);
var
  Quantidade: Extended;
begin
  If key = #13 then
  Begin
    Key:= #0;
    Perform(Wm_NextDlgCtl,0,0);
  End;

  If key = '*' then
  Begin
    Key := #0;
    try
      Quantidade:=StrToFloat(editCodigo.Text);
      if (Quantidade <= 0) or (Quantidade > 999) then
      begin
        Application.MessageBox('Quantidade inválida.', 'Erro', MB_OK + MB_ICONERROR);
        editCodigo.Text := '';
        editQuantidade.Text := '1';
      end
      else
      begin
        editQuantidade.Text := editCodigo.Text;
        editCodigo.Text := '';
      end;
    except
      Application.MessageBox('Quantidade inválida.', 'Erro', MB_OK + MB_ICONERROR);
      editCodigo.Text := '';
      editQuantidade.Text := '1';
    end;
  end;
end;

procedure TFDAV.IdentificaCliente;
begin
  if (StatusDav <> 3) and (StatusDav <> 4 ) then
  begin
      begin
        Application.CreateForm(TFProcuraCliente, FProcuraCliente);
        FProcuraCliente.ShowModal;
        if FProcuraCliente.IdClientePassou > 0 then
          editCodigoCliente.Text := IntToStr(FProcuraCliente.IdClientePassou);
          editCodigoCliente.SetFocus;
          keybd_event(VK_Return, 0, 0, 0);
      end
    end
  else
    Application.MessageBox('Emissão de DAV em Estado de Alteração ou Exclusão.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION);
end;

procedure TFDAV.localizaClienteId;
begin
   Cliente := TClienteController.ConsultaPeloId(StrToint(editCodigoCliente.Text));

  if Cliente.Id <> 0 then
    begin
    editCodigoCliente.Text    := IntToStr(Cliente.Id);
    EditNome.Text             := Cliente.Nome;
    editCpfCnpj.Text          := Cliente.CPFOuCNPJ;
    end;

end;

procedure TFDAV.localizaClienteCpfCnpj;
begin
  Cliente := TClienteController.ConsultaCPFCNPJ(editCpfCnpj.Text);

  if Cliente.Id <> 0 then
    editCodigoCliente.Text    := IntToStr(Cliente.Id);
    EditNome.Text             := Cliente.Nome;
    editCpfCnpj.Text          := Cliente.CPFOuCNPJ;
end;

procedure TFDAV.Confirma;
var
  DAVControl : TDAVController;
  DAVDetalhe: TDAVDetalheVO;
  ListaDAVDetalhe: TObjectList<TDAVDetalheVO>;
begin
  if (EditNome.Text <> '') and (EditCPFCNPJ.Text <> '') then
  begin
    if (ValidaCPF(EditCPFCNPJ.Text)) or (ValidaCNPJ(EditCPFCNPJ.Text)) then
    begin
    if FDataModule.CDSDAV.RecordCount > 0 then
    begin
    DAVControl := TDAVController.Create;
    ListaDAVDetalhe := TObjectList<TDAVDetalheVO>.Create;
    //
    DAVCabecalho.IdEmpresa := Constantes.TConstantes.EMPRESA_BALCAO;
    if (Cliente.Id > 1) then
    DAVCabecalho.IdCliente := Cliente.Id
    else
    DAVCabecalho.IdCliente := 1;
    DAVCabecalho.NomeDestinatario := EditNome.Text;
    DAVCabecalho.CpfCnpjDestinatario := EditCPFCNPJ.Text;
    FDataModule.CDSDAV.DisableControls;
    FDataModule.CDSDAV.First;
    while not FDataModule.CDSDAV.Eof do
    begin
      DAVDetalhe := TDAVDetalheVO.Create;
      DAVDetalhe.IdProduto := FDataModule.CDSDAV.FieldByName('ID_PRODUTO').AsInteger;
      DAVDetalhe.Item := FDataModule.CDSDAV.FieldByName('ITEM').AsInteger;
      DAVDetalhe.Quantidade := FDataModule.CDSDAV.FieldByName('QUANTIDADE').AsFloat;
      DAVDetalhe.ValorUnitario := FDataModule.CDSDAV.FieldByName('VALOR_UNITARIO').AsFloat;
      DAVDetalhe.ValorTotal := FDataModule.CDSDAV.FieldByName('VALOR_TOTAL').AsFloat;
      DAVDetalhe.Cancelado := FDataModule.CDSDAV.FieldByName('CANCELADO').AsString;
      ListaDAVDetalhe.Add(DAVDetalhe);
      FDataModule.CDSDAV.Next;
    end;
    CodigoDAV := DAVControl.InsereDAV(DAVCabecalho, ListaDAVDetalhe);
    ShowMessage('Orçamento(DAV) inserido com sucesso. Número: ' + IntToStr(CodigoDAV));
    StatusDav := 0;
    if Application.MessageBox('Deseja Imprimir o DAV?', 'Pergunta do sistema', MB_YESNO + MB_ICONQUESTION) = IDYES then
      ImprimirDAV;
    TelaPadrao;
    AtualizaTotais;
    Cliente := nil;
    FDataModule.CDSDAV.EnableControls;
    EditCodigo.SetFocus;
    end;
    end
    else
  begin
    Application.MessageBox('Não é possível emitir um DAV com CPF ou CNPJ inválido.'+#13+'            Preenchimento correto é obrigatório!', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION);
    editCodigoCliente.SetFocus;
  end;
  end
  else
  begin
    Application.MessageBox('Nome e CPF/CNPJ do destinatário são obrigatórios.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION);
    editCodigoCliente.SetFocus;
  end;
end;

procedure TFDAV.ExcluirItem;
var
AuxProduto: string;
begin
  if FDataModule.CDSDAV.RecordCount > 0 then
  begin
      if not (FDataModule.CDSDAV.FieldByName('CANCELADO').AsAnsiString =  'S') then
      begin
        if Application.MessageBox('Deseja realmente excluir o registro selecionado?', 'Pergunta do sistema', MB_YESNO + MB_ICONQUESTION) = IDYES then
        begin
          try
          GridItens.Columns[0].ReadOnly := False;
          GridItens.Columns[1].ReadOnly := False;
          GridItens.Columns[2].ReadOnly := False;
          GridItens.Columns[4].ReadOnly := False;
          GridItens.Columns[5].ReadOnly := False;
          SubTotal := SubTotal - FDataModule.CDSDAV.FieldByName('VALOR_TOTAL').AsFloat;
          AtualizaTotais;
          FDataModule.CDSDAV.Edit;
          AuxProduto := FDataModule.CDSDAV.FieldByName('DESCRICAO_PDV').AsAnsiString;
          FDataModule.CDSDAV.FieldByName('DESCRICAO_PDV').AsAnsiString := '***cancelado*** ' + AuxProduto ;
          FDataModule.CDSDAV.FieldByName('CANCELADO').AsAnsiString :=  'S';
          FDataModule.CDSDAV.FieldByName('VALOR_UNITARIO').AsFloat := 0;
          FDataModule.CDSDAV.Post;


          GridItens.SetFocus;

          GridItens.Columns[0].ReadOnly := False;
          GridItens.Columns[1].ReadOnly := True;
          GridItens.Columns[2].ReadOnly := True;
          GridItens.Columns[4].ReadOnly := True;
          GridItens.Columns[5].ReadOnly := True;

          EditCodigo.SetFocus;

          except
            Application.MessageBox('Ocorreu um erro. Exclusão não realizada.', 'Erro do sistema', MB_OK + MB_ICONERROR);
          end;
          end;
    end
    else
        Application.MessageBox('Item já Excluído.', 'Não autorizado!', MB_OK + MB_ICONERROR);
  end
  else
  Application.MessageBox('Não Existe Produto Disponível Para Exclusão.', 'Não autorizado!', MB_OK + MB_ICONERROR);
end;

procedure TFDAV.DescontoOuAcrescimo;
var
  Operacao: integer;
  {
  0-Desconto em Dinheiro
  1-Desconto Percentual
  2-Acréscimo em Dinheiro
  3-Acréscimo Percentual
  5-Cancela o Desconto ou Acréscimo
  }
  Valor: Extended;
begin
    Application.CreateForm(TFLoginGerenteSupervisor, FLoginGerenteSupervisor);
    try
      if (FLoginGerenteSupervisor.ShowModal = MROK) then
      begin
        if FLoginGerenteSupervisor.LoginOK then
        begin
          Application.CreateForm(TFDescontoAcrescimo, FDescontoAcrescimo);
          FDescontoAcrescimo.Caption := 'Desconto em Dinheiro';
          try
            if (FDescontoAcrescimo.ShowModal = MROK) then
            begin
              Operacao := FDescontoAcrescimo.ComboOperacao.ItemIndex;
              Valor := StrToFloat(FDescontoAcrescimo.EditEntrada.Text);

              //desconto em valor
              if Operacao = 0 then
              begin
                if Valor >= DAVCabecalho.Valor then
                  Application.MessageBox('Desconto não pode ser superior ou igual ao valor da venda.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION)
                else
                begin
                  if Valor <= 0 then
                    Application.MessageBox('Valor zerado ou negativo. Operação não realizada.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION)
                  else
                  begin
                    Desconto := Valor;
                    DAVCabecalho.TaxaAcrescimo := 0;
                    Acrescimo := 0;
                    AtualizaTotais;
                  end;
                end;
              end;

              //desconto em taxa
              if Operacao = 1 then
              begin
                if Valor > 99 then
                  Application.MessageBox('Desconto não pode ser superior a 100%.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION)
                else
                begin
                  if Valor <= 0 then
                    Application.MessageBox('Valor zerado ou negativo. Operação não realizada.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION)
                  else
                  begin
                    DAVCabecalho.TaxaDesconto := Valor;
                    Desconto := TruncaValor(SubTotal * (Valor/100),Constantes.TConstantes.DECIMAIS_VALOR);
                    DAVCabecalho.TaxaAcrescimo := 0;
                    Acrescimo := 0;
                    AtualizaTotais;
                  end;
                end;
              end;

              //acrescimo em valor
              if Operacao = 2 then
              begin
                if Valor <= 0 then
                  Application.MessageBox('Valor zerado ou negativo. Operação não realizada.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION)
                else
                begin
                  Acrescimo := Valor;
                  DAVCabecalho.TaxaDesconto := 0;
                  Desconto := 0;
                  AtualizaTotais;
                end;
              end;

              //acrescimo em taxa
              if Operacao = 3 then
              begin
                if Valor <= 0 then
                  Application.MessageBox('Valor zerado ou negativo. Operação não realizada.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION)
                else
                begin
                  DAVCabecalho.TaxaAcrescimo := Valor;
                  Acrescimo := TruncaValor(SubTotal * (Valor/100),Constantes.TConstantes.DECIMAIS_VALOR);
                  DAVCabecalho.TaxaDesconto := 0;
                  Desconto := 0;
                  AtualizaTotais;
                end;
              end;

              //cancela desconto ou acrescimo
              if Operacao = 5 then
              begin
                DAVCabecalho.TaxaAcrescimo := 0;
                DAVCabecalho.TaxaDesconto := 0;
                Acrescimo := 0;
                Desconto := 0;
                AtualizaTotais;
              end;

            end;
          finally
            if Assigned(FDescontoAcrescimo) then
              FDescontoAcrescimo.Free;
          end;
        end
        else
          Application.MessageBox('Login - dados incorretos.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    finally
        if Assigned(FLoginGerenteSupervisor) then
          FLoginGerenteSupervisor.Free;
    end;
end;

procedure TFDAV.ImprimirDAV;
var
  ReportManager: Variant;
begin
  if (CodigoDAV <> 0) and (StatusDav = 0) then
  begin
    ReportManager := CreateOleObject('ReportMan.ReportManX');
    ReportManager.Preview := true;
    ReportManager.ShowProgress := true;
    ReportManager.ShowPrintDialog := true;
    ReportManager.Filename := 'DAV.rep';
    ReportManager.SetParamValue('ID',CodigoDAV);
    ReportManager.execute;
    StatusDav := 1;
    CodigoDAV := 0
  end
  else
    Application.MessageBox('DAV ainda não gravado, ou já impresso.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION);
end;

procedure TFDAV.FormActivate(Sender: TObject);
begin
    PodeFinalizar               := 1;
    StatusDav                   := 0;
    Cliente := TClienteVO.Create;
    DAVCabecalho := TDAVVO.Create;
    EditCodigo.SetFocus;
end;

procedure TFDAV.AtualizaTotais;
begin
  DAVCabecalho.SubTotal := SubTotal;
  DAVCabecalho.Desconto := Desconto;
  DAVCabecalho.Acrescimo := Acrescimo;

  DAVCabecalho.Valor := SubTotal + (Acrescimo - Desconto);

  if Desconto >  0 then
  begin
    lblDescAcrescDescricao.Caption := 'Desconto:';
    LabelDescontoAcrescimo.Caption := FormatFloat('0.00',DAVCabecalho.Desconto);
    lblDescAcrescDescricao.Font.Color := clRed;
    LabelDescontoAcrescimo.Font.Color := clRed;
  end
  else if Acrescimo >  0 then
  begin
    lblDescAcrescDescricao.Caption := 'Acréscimo:';
    LabelDescontoAcrescimo.Caption := FormatFloat('0.00',DAVCabecalho.Acrescimo);
    lblDescAcrescDescricao.Font.Color := clGreen;
    LabelDescontoAcrescimo.Font.Color := clGreen;
  end
  else
    begin
    LabelDescontoAcrescimo.Caption := '';
    lblDescAcrescDescricao.Caption := '';
    end;

  lblSubTotal.Caption := FormatFloat('0.00', DAVCabecalho.SubTotal);
  lblValorTotal.Caption := FormatFloat('0.00', DAVCabecalho.Valor);

end;

procedure TFDAV.TelaPadrao;
begin
    limpaCampos;
    TotalGeral  := 0;
    SubTotal    := 0;
    Desconto    := 0;
    Acrescimo   := 0;
    SeqItem     := 0;
end;

procedure TFDAV.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Application.MessageBox('Deseja Realmente Fechar a Tela de Orçamento(DAV)?', 'Sair do Sistema', MB_YesNo + MB_IconQuestion) <> IdYes then
    Action := caNone
  else
    Action := caFree;
end;

procedure TFDAV.FormCreate(Sender: TObject);
begin
    ConfiguraCDSGrid;
    CodigoDAV := 0;
    Application.OnHint := ShowHint;
end;

procedure TFDAV.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if key = 112 then
     LocalizaProduto;
  if key = 117 then
     IdentificaCliente;
  if key = 119 then
     ExcluirItem;
  if key = 121 then
    DescontoOuAcrescimo;
  if key = 122 then
    ImprimirDAV;
  if key = 123 then
    Confirma;
  if key = 27 then
    Close;
end;

procedure TFDAV.limpaCampos;
begin
  editcpfcnpj.Text                  := '';
  editNome.Text                     := '';
  editQuantidade.Text               := '1,000';
  editUnitario.Text                 := '0,000';
  editTotalItem.Text                := '0,000';
  labelDescricaoProduto.Caption     := '';
  editCodigo.Text                   := '';
  editCodigoCliente.Text            := '';
  FDataModule.CDSDAV.EmptyDataSet;
end;

{desmembrando editcodigo}
procedure TFDAV.ConsultaProduto(Codigo:String);
begin
  Produto := TProdutoController.Consulta(Codigo);
end;

procedure TFDAV.ConsultaProdutoCodigoBalanca(CodigoBalanca: Integer);
begin
  Produto := TProdutoController.ConsultaCodigoBalanca(CodigoBalanca);
end;

procedure TFDAV.ConsultaProdutoCodigoInterno(CodigoInterno: string);
begin
  Produto := TProdutoController.ConsultaCodigoInterno(CodigoInterno);
end;

procedure TFDAV.ConsultaProdutoId(id: Integer);
begin
  Produto := TProdutoController.ConsultaId(Id);
end;

procedure TFDAV.MensagemDeProdutoNaoEncontrado;
begin
  Application.MessageBox('Código não encontrado.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION);
  editUnitario.Text := '0';
  editTotalItem.Text := '0';
  editQuantidade.Text := '1';
  labelDescricaoProduto.Caption := '';
  editCodigo.SetFocus;
end;

function TFDAV.DesmembraCodigoDigitado(var CodigoDeBarraOuDescricaoOuIdProduto: string; var Preco, Qtde: Extended): integer; // criado por jose rodrigues

var IdentificadorBalanca, vCodDescrId , vPesoOuValor:string;
    DigitosUsadosCodigoBalanca, DigitosUsadosPrecoQtde:integer;

begin
 { Apenas para complementar, podem haver algumas variações na etiqueta impressa pela impressora.

  Essas variações podem ser:

  A - 2 C C C C 0 T T T T T T DV           Onde:         2 - Digito 2 sempre
  B - 2 C C C C 0 0 P P P P P DV                         C - Código do Produto
  C - 2 C C C C C T T T T T T DV                         0 - Espaço, não utilizado
  D - 2 C C C C C 0 P P P P P DV                         T - Valor Total a Pagar
  E - 2 C C C C C C P P P P P DV                         P - Peso ou Quantidade
                                                         DV- Digito Verificador EAN-13    }

  IdentificadorBalanca := '2';     // colocar na configuração do caixa
  DigitosUsadosCodigoBalanca := 4; //  colocar na configuração do caixa -- pode ser 4 , 5 ou 6
  DigitosUsadosPrecoQtde := 6;    // colocar na configuração do caixa pode ser 5 ou 6
  vPesoOuValor := 'VALOR';         // colocar na configuração do caixa -- pode ser VALOR OU PESO
  vCodDescrId := CodigoDeBarraOuDescricaoOuIdProduto;

  Result:= 0;

  if Length(CodigoDeBarraOuDescricaoOuIdProduto) <= 20 then
  begin
     ConsultaProdutoCodigoInterno(CodigoDeBarraOuDescricaoOuIdProduto);
     if Produto.Id <> 0 then
     begin
       Result:=5;
       exit;
     end;
  end;

  if (Length(DevolveInteiro(vCodDescrId))= 13) or (Length(DevolveInteiro(vCodDescrId))= 14) then
  begin
    if (Length(DevolveInteiro(vCodDescrId))= 13) and (IdentificadorBalanca=Copy(vCodDescrId,1,1)) then
    begin
      if vPesoOuValor = 'VALOR' then
      begin
        Preco:=StrToFloat(Copy(vCodDescrId,13-DigitosUsadosPrecoQtde,DigitosUsadosPrecoQtde))/100;
        CodigoDeBarraOuDescricaoOuIdProduto:=Copy(vCodDescrId,2,DigitosUsadosCodigoBalanca);
        Result:= 1;
      end else
      begin
        CodigoDeBarraOuDescricaoOuIdProduto:=Copy(vCodDescrId,2,DigitosUsadosCodigoBalanca);
        Qtde:=StrToFloat(Copy(vCodDescrId,13-DigitosUsadosPrecoQtde,DigitosUsadosPrecoQtde))/1000;
        Result:=1;
      end;
    end else
    begin
      CodigoDeBarraOuDescricaoOuIdProduto:=vCodDescrId;
      Result:= 2;
    end;
  end else
  if Length(DevolveInteiro(vCodDescrId))= Length(vCodDescrId) then
  begin
    CodigoDeBarraOuDescricaoOuIdProduto:=copy(vCodDescrId,1,14);
    Result:= 4;
  end else
  begin
    CodigoDeBarraOuDescricaoOuIdProduto:=vCodDescrId;
    Result:= 3;
  end;
end;

procedure TFDAV.VendeItem;
begin
    if Produto.ValorVenda > 0 then
    begin
    inc(SeqItem);
    FDAV.GridItens.Columns[0].ReadOnly := False;
    FDAV.GridItens.Columns[1].ReadOnly := False;
    FDAV.GridItens.Columns[2].ReadOnly := False;
    FDAV.GridItens.Columns[3].ReadOnly := False;
    FDAV.GridItens.Columns[4].ReadOnly := False;
    FDAV.GridItens.Columns[5].ReadOnly := False;


    FDataModule.CDSDAV.Append;
    FDataModule.CDSDAV.FieldByName('ITEM').AsInteger := SeqItem;
    FDataModule.CDSDAV.FieldByName('GTIN').AsAnsiString := Produto.GTIN;
    FDataModule.CDSDAV.FieldByName('DESCRICAO_PDV').AsAnsiString := Produto.DescricaoPDV;
    FDataModule.CDSDAV.FieldByName('VALOR_UNITARIO').AsAnsiString := editUnitario.Text;
    FDataModule.CDSDAV.FieldByName('QUANTIDADE').AsFloat := StrToFloat(editQuantidade.Text);
    FDataModule.CDSDAV.FieldByName('VALOR_TOTAL').AsFloat :=  StrToFloat(editTotalItem.Text);
    FDataModule.CDSDAV.FieldByName('ID_PRODUTO').AsInteger := Produto.Id;
    FDataModule.CDSDAV.FieldByName('CANCELADO').AsAnsiString := 'N';
    FDataModule.CDSDAV.Post;

    FDAV.GridItens.Columns[0].ReadOnly := False;
    FDAV.GridItens.Columns[1].ReadOnly := True;
    FDAV.GridItens.Columns[2].ReadOnly := True;
    FDAV.GridItens.Columns[3].ReadOnly := True;
    FDAV.GridItens.Columns[4].ReadOnly := True;
    FDAV.GridItens.Columns[5].ReadOnly := True;

    FDAV.GridItens.SetFocus;
    end
    else
        Application.MessageBox('Produto não pode ser vendido com valor zerado ou negativo.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION);

end;

procedure TFDAV.LocalizaProduto;
begin
  Application.CreateForm(TFImportaProduto, FImportaProduto);
  UImportaProduto.QuemChamou := 'DAV';
  FImportaProduto.ShowModal;
  if (trim(editCodigo.Text)<>'') then
  begin
    editCodigo.SetFocus;
    IniciaVendaDeItens;
  end;
end;

procedure TFDAV.IniciaVendaDeItens;
var
  Unitario, Quantidade, Total: Extended;
  vTipo:integer;
  vCodigoDeBarraOuDescricaoOuIdProduto: string;
  vPreco, vQtde: Extended;
begin
if StatusDav <> 3 then
begin
    if trim(editCodigo.Text) <> '' then
    begin
      vCodigoDeBarraOuDescricaoOuIdProduto:=trim(editCodigo.Text);
      vpreco:=0;
      vQtde:=0;

      vTipo:= DesmembraCodigoDigitado(vCodigoDeBarraOuDescricaoOuIdProduto, vPreco,vQtde);

      case vTipo of
        0:begin
          MensagemDeProdutoNaoEncontrado;
          abort;
        end;
        1:ConsultaProdutoCodigoBalanca(StrToInt(vCodigoDeBarraOuDescricaoOuIdProduto));
        2:ConsultaProduto(vCodigoDeBarraOuDescricaoOuIdProduto);
        3:begin
          Application.CreateForm(TFImportaProduto, FImportaProduto);
          UImportaProduto.QuemChamou := 'DAV';
          FImportaProduto.EditLocaliza.Text:= vCodigoDeBarraOuDescricaoOuIdProduto;
          FImportaProduto.ShowModal;
          if (Length(DevolveInteiro(editCodigo.text))) = (Length(trim(editCodigo.text))) then
          begin
            Produto.Id :=0;
            ConsultaProdutoId(StrToInt64(editCodigo.text));
          end else
          begin
            MensagemDeProdutoNaoEncontrado;
            abort;
          end;
        end;
        4:ConsultaProdutoId(StrToInt64(vCodigoDeBarraOuDescricaoOuIdProduto));

      end;
      Application.ProcessMessages;

      if Produto.Id <> 0 then
      begin
        if vQtde > 0  then
           editQuantidade.Value:= vQtde;

        if vpreco > 0 then
           editQuantidade.Text:= FormataFloat('Q',(vPreco/Produto.ValorVenda));

        if (Produto.PodeFracionarUnidade = 'N') and (Frac(StrToFloat(EditQuantidade.Text))>0) then
        begin
          Application.MessageBox('Produto não pode ser vendido com quantidade fracionada.', 'Informação do Sistema', MB_OK + MB_ICONINFORMATION);
          editUnitario.Text := '0';
          editTotalItem.Text := '0';
          editQuantidade.Text := '1';
          labelDescricaoProduto.Caption := '';
          editCodigo.Text := '';
          editCodigo.SetFocus;
        end
        else
        begin
          editUnitario.Text := FormataFloat('V',Produto.ValorVenda);
          labelDescricaoProduto.Caption := Produto.DescricaoPDV;
          Unitario := StrToFloat(editUnitario.Text);
          Quantidade := StrToFloat(editQuantidade.Text);

          VendeItem;

          Total := TruncaValor(Unitario * Quantidade, Constantes.TConstantes.DECIMAIS_VALOR);
          editTotalItem.Text := FormataFloat('V', Total);

          AtualizaTotais;
          editCodigo.Clear;
          editCodigo.SetFocus;
          editQuantidade.Text := '1';
          Application.ProcessMessages;
        end;
      end
      else
      begin
         MensagemDeProdutoNaoEncontrado;
      end;
    end;
  end;

end;

procedure TFDAV.editCodigoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of VK_RETURN:
    begin
     IniciaVendaDeItens;
    end;
  end;
end;

//ate aqui

//****************************************************************************//
// Aparência e controle dos painéis com as funções do programa - F1 a F12     //
//****************************************************************************//

procedure TFDAV.panelF1MouseEnter(Sender: TObject);
begin
  panelF1.BevelOuter := bvRaised;
  panelF1.BevelWidth := 2;
end;

procedure TFDAV.panelF1MouseLeave(Sender: TObject);
begin
  panelF1.BevelOuter := bvNone;
end;

procedure TFDAV.panelF1Click(Sender: TObject);
begin
  LocalizaProduto;
end;

procedure TFDAV.panelF6MouseEnter(Sender: TObject);
begin
  panelF6.BevelOuter := bvRaised;
  panelF6.BevelWidth := 2;
end;

procedure TFDAV.panelF6MouseLeave(Sender: TObject);
begin
  panelF6.BevelOuter := bvNone;
end;

procedure TFDAV.panelF6Click(Sender: TObject);
begin
  IdentificaCliente;
end;

procedure TFDAV.panelF8MouseEnter(Sender: TObject);
begin
  panelF8.BevelOuter := bvRaised;
  panelF8.BevelWidth := 2;
end;

procedure TFDAV.panelF8MouseLeave(Sender: TObject);
begin
  panelF8.BevelOuter := bvNone;
end;

procedure TFDAV.panelF8Click(Sender: TObject);
begin
   ExcluirItem;
end;

procedure TFDAV.panelF10MouseEnter(Sender: TObject);
begin
  panelF10.BevelOuter := bvRaised;
  panelF10.BevelWidth := 2;
end;

procedure TFDAV.panelF10MouseLeave(Sender: TObject);
begin
  panelF10.BevelOuter := bvNone;
end;

procedure TFDAV.panelF10Click(Sender: TObject);
begin
  DescontoOuAcrescimo;
end;

procedure TFDAV.panelF11MouseEnter(Sender: TObject);
begin
  panelF11.BevelOuter := bvRaised;
  panelF11.BevelWidth := 2;
end;

procedure TFDAV.panelF11MouseLeave(Sender: TObject);
begin
  panelF11.BevelOuter := bvNone;
end;

procedure TFDAV.panelF11Click(Sender: TObject);
begin
    ImprimirDAV;
end;

procedure TFDAV.panelF12MouseEnter(Sender: TObject);
begin
  panelF12.BevelOuter := bvRaised;
  panelF12.BevelWidth := 2;
end;

procedure TFDAV.panelF12MouseLeave(Sender: TObject);
begin
  panelF12.BevelOuter := bvNone;
end;

procedure TFDAV.panelF12Click(Sender: TObject);
begin
    Confirma;
end;

procedure TFDAV.PanelEscMouseEnter(Sender: TObject);
begin
 PanelEsc.BevelOuter := bvRaised;
 PanelEsc.BevelWidth := 2;
end;

procedure TFDAV.PanelEscMouseLeave(Sender: TObject);
begin
  PanelEsc.BevelOuter := bvNone;
end;

procedure TFDAV.PanelEscClick(Sender: TObject);
begin
   Close;
end;

end.
