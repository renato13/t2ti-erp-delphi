{*******************************************************************************
Title: T2Ti ERP
Description: Classe de controle da pre-venda para o sistema de balcão do PAF-ECF.

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
unit PreVendaController;

interface

uses
  Classes, SQLExpr, SysUtils, PreVendaDetalheVO, PreVendaVO, Generics.Collections, DB;

type
  TPreVendaController = class
  protected
  public
    function InserePreVenda(PreVendaCabecalho:TPreVendaVO;ListaPreVendaDetalhe:TObjectList<TPreVendaDetalheVO>): Integer;
  end;

implementation

uses UDataModule;

var
  ConsultaSQL: String;
  Query: TSQLQuery;

function TPreVendaController.InserePreVenda(PreVendaCabecalho:TPreVendaVO;ListaPreVendaDetalhe:TObjectList<TPreVendaDetalheVO>): Integer;
var
  i:integer;
begin
  //insere a PV no cabecalho
  ConsultaSQL :=
    'insert into ECF_PRE_VENDA_CABECALHO (' +
    'ID_CLIENTE, NOME_DESTINATARIO, CPF_CNPJ_DESTINATARIO, ' +
    'DATA_PV, HORA_PV, ' +
    'SITUACAO, SUBTOTAL, DESCONTO, ' +
    'ACRESCIMO, VALOR) values (' +
    ':pIdCliente,:pNomeDestinatario,:pCpfCnpjDestinatario,' +
    ':pDataEmissao,:pHoraEmissao,' +
    ':pSituacao,:pSubTotal, :pDesconto,' +
    ':pAcrescimo,:pValor)';
  try
    try
      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;

      Query.ParamByName('pIdCliente').AsInteger := PreVendaCabecalho.IdCliente;
      Query.ParamByName('pNomeDestinatario').AsString := PreVendaCabecalho.NomeDestinatario;
      Query.ParamByName('pCpfCnpjDestinatario').AsString := PreVendaCabecalho.CpfCnpjDestinatario;
      Query.ParamByName('pDataEmissao').AsString := FormatDateTime('yyyy-mm-dd', now);
      Query.ParamByName('pHoraEmissao').AsString := FormatDateTime('hh:nn:ss', now);
      Query.ParamByName('pSituacao').AsString := 'P';
      Query.ParamByName('pSubTotal').AsFloat := PreVendaCabecalho.SubTotal;
      Query.ParamByName('pDesconto').AsFloat := PreVendaCabecalho.Desconto;
      Query.ParamByName('pAcrescimo').AsFloat := PreVendaCabecalho.Acrescimo;
      Query.ParamByName('pValor').AsFloat := PreVendaCabecalho.Valor;

      Query.ExecSQL();

      { TODO : Esse sistema pode estar rodando em rede. E agora? Como pegar o ID correto da PV? }
      //como não há obrigatoriedade de lançar as Pre-Vendas e DAV's em modo concomitante. Lança
      //em um Servidor de Banco de Dados. Coloquei a conexão em um Ini provisório
      //ateh terminar o meu framework
      ConsultaSQL := 'select max(ID) as ID from ECF_PRE_VENDA_CABECALHO';
      Query.sql.Text := ConsultaSQL;
      Query.Open();

      PreVendaCabecalho.Id := Query.FieldByName('ID').AsInteger;
    except
    end;
  finally
    Query.Free;
  end;

  //insere os dados na tabela de detalhes
  ConsultaSQL :=
    'insert into ECF_PRE_VENDA_DETALHE (' +
    'ID_PRODUTO,' +
    'ITEM,' +
    'ID_ECF_PRE_VENDA_CABECALHO,' +
    'QUANTIDADE,' +
    'VALOR_UNITARIO,' +
    'VALOR_TOTAL) values (' +
    ':pIdProduto,' +
    ':pItem,' +
    ':pIdPreVenda,' +
    ':pQuantidade,' +
    ':pValorUnitario,' +
    ':pValorTotal)';
  try
    try
      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;
      for i := 0 to ListaPreVendaDetalhe.Count - 1 do
      begin
        Query.ParamByName('pIdProduto').AsInteger := TPreVendaDetalheVO(ListaPreVendaDetalhe.Items[i]).IdProduto;
        Query.ParamByName('pItem').AsInteger := TPreVendaDetalheVO(ListaPreVendaDetalhe.Items[i]).Item;
        Query.ParamByName('pIdPreVenda').AsInteger := PreVendaCabecalho.Id;
        Query.ParamByName('pQuantidade').AsFloat := TPreVendaDetalheVO(ListaPreVendaDetalhe.Items[i]).Quantidade;
        Query.ParamByName('pValorUnitario').AsFloat := TPreVendaDetalheVO(ListaPreVendaDetalhe.Items[i]).ValorUnitario;
        Query.ParamByName('pValorTotal').AsFloat := TPreVendaDetalheVO(ListaPreVendaDetalhe.Items[i]).ValorTotal;
        Query.ExecSQL();
      end;
    except
    end;
  finally
    Query.Free;
  end;

  result := PreVendaCabecalho.Id;
end;


end.
