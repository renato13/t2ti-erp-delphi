{*******************************************************************************
Title: T2Ti ERP
Description: Classe de controle do DAV.

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
unit DAVController;

interface

uses
  Classes, SQLExpr, SysUtils, DAVDetalheVO, Generics.Collections, DB, DAVVO, Biblioteca;

type
  TDAVController = class
  protected
  public
    class Function CarregaDAV(Id: Integer): TObjectList<TDAVDetalheVO>;
    class Procedure FechaDAV(Id: Integer; CCF: Integer; COO: Integer);
    class Procedure MesclaDAV(ListaDAVCabecalho:TObjectList<TDAVVO>;ListaDAVDetalhe:TObjectList<TDAVDetalheVO>);
    class function ListaDAVPeriodo(DataInicio:String; DataFim:String): TObjectList<TDAVVO>;
    class function ConsultaDAVId(Id:Integer): TDAVVO;
  end;

implementation

uses UDataModule, UEcf, UCaixa, ClienteVO;

var
  ConsultaSQL: String;
  Query: TSQLQuery;

class function TDAVController.CarregaDAV(Id: Integer): TObjectList<TDAVDetalheVO>;
var
  ListaDAV: TObjectList<TDAVDetalheVO>;
  DAVDetalhe: TDAVDetalheVO;
  TotalRegistros: Integer;
begin
  //verifica se existe o DAV solicitado
  ConsultaSQL :=
    'select count(*) as TOTAL from ECF_DAV_CABECALHO ' +
    'where SITUACAO <> ' + QuotedStr('E') + ' and SITUACAO <> ' + QuotedStr('M') + ' and ID=' + IntToStr(Id);

  try
    try
      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;
      Query.Open;
      TotalRegistros := Query.FieldByName('TOTAL').AsInteger;

      //caso exista o DAV, procede com a importação do mesmo
      if TotalRegistros > 0 then
      begin
        //verifica se existem itens para o DAV
        ConsultaSQL :=
          'select count(*) as TOTAL from ECF_DAV_DETALHE where ID_ECF_DAV='+IntToStr(Id);
        Query.sql.Text := ConsultaSQL;
        Query.Open;
        TotalRegistros := Query.FieldByName('TOTAL').AsInteger;

        //caso existam itens no detalhe
        if TotalRegistros > 0 then
        begin             //****acrescentada daqui****
          //carrega cliente da Pré-Venda
          Cliente := TClienteVO.Create;
          ConsultaSQL :=
            'select * from ECF_DAV_CABECALHO where ID='+IntToStr(Id);
          Query.sql.Text := ConsultaSQL;
          Query.Open;
          {Todo: Pré venda só para clientes cadastrados ou continua dessa forma}
          //quando cliente não cadastrado, pode colocar um cadastro como cliente diversos id=2,
          //como o cliente 1=venda ao consumidor, quando não informado o cliente o sistema emite
          //a venda para o cliente 1= venda ao cons... automaticamente
          Cliente.Id := Query.FieldByName('ID_CLIENTE').AsInteger;
          Cliente.Nome := Query.FieldByName('NOME_DESTINATARIO').AsString;
          Cliente.CPFOuCNPJ := Query.FieldByName('CPF_CNPJ_DESTINATARIO').AsString;

          //carrega desconto ou acrescimo
          UCaixa.Desconto := Query.FieldByName('DESCONTO').AsFloat;
          UCaixa.Acrescimo := Query.FieldByName('ACRESCIMO').AsFloat;
                               //****ateh aqui****

          ListaDAV := TObjectList<TDAVDetalheVO>.Create;

          ConsultaSQL :=
            'select * from ECF_DAV_DETALHE where ID_ECF_DAV='+IntToStr(Id);
          Query.sql.Text := ConsultaSQL;
          Query.Open;
          Query.First;
          while not Query.Eof do
          begin
            DAVDetalhe := TDAVDetalheVO.Create;
            DAVDetalhe.Id := Query.FieldByName('ID').AsInteger;
            DAVDetalhe.IdDAV := Id;
            DAVDetalhe.IdProduto := Query.FieldByName('ID_PRODUTO').AsInteger;
            DAVDetalhe.Quantidade := Query.FieldByName('QUANTIDADE').AsInteger;
            DAVDetalhe.ValorUnitario := Query.FieldByName('VALOR_UNITARIO').AsFloat;
            DAVDetalhe.ValorTotal := Query.FieldByName('VALOR_TOTAL').AsFloat;
            DAVDetalhe.Cancelado := Query.FieldByName('CANCELADO').AsString;
            ListaDAV.Add(DAVDetalhe);
            Query.next;
          end;
          result := ListaDAV;
        end
        else
          result := nil;
      end
      //caso não exista o DAV, retorna um ponteiro nulo
      else
        result := nil;
    except
      result := nil;
    end;
  finally
    Query.Free;
  end;
end;

class procedure TDAVController.FechaDAV(Id: Integer; CCF: Integer; COO: Integer);
var
  DAVCabecalho: TDAVVO;
  Tripa, Hash: String;
begin
  ConsultaSQL :=
    'update ECF_DAV_CABECALHO set ' +
    'SITUACAO=:pSituacao, '+
    'CCF=:pCCF, '+
    'COO=:pCOO '+
    ' where ID = :pId';

  try
    try
      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;
      Query.ParamByName('pId').AsInteger := Id;
      Query.ParamByName('pCCF').AsInteger := CCF;
      Query.ParamByName('pCOO').AsInteger := COO;
      Query.ParamByName('pSituacao').AsString := 'E';
      Query.ExecSQL();
      Query.Free;

      //calcula e grava o hash
      DAVCabecalho := ConsultaDAVId(Id);
      Tripa :=  IntToStr(DAVCabecalho.Id) +
                IntToStr(DAVCabecalho.CCF) +
                IntToStr(DAVCabecalho.COO) +
                DAVCabecalho.DataEmissao +
                DAVCabecalho.HoraEmissao +
                FormataFloat('V',DAVCabecalho.Valor);

      Hash := MD5String(Tripa);

      ConsultaSQL :=
        'update ECF_DAV_CABECALHO set ' +
        'HASH_TRIPA=:pHash ' +
        ' where ID = :pId';

      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;
      Query.ParamByName('pHash').AsString := Hash;
      Query.ParamByName('pId').AsInteger := Id;
      Query.ExecSQL();

    except
    end;
  finally
    Query.Free;
  end;
end;

class procedure TDAVController.MesclaDAV(ListaDAVCabecalho:TObjectList<TDAVVO>;ListaDAVDetalhe:TObjectList<TDAVDetalheVO>);
var
  i:integer;
  NovoDAVCabecalho: TDAVVO;
begin
  //inicia e configura o novo DAV
  NovoDAVCabecalho := TDAVVO.Create;
  NovoDAVCabecalho.NomeDestinatario := TDAVVO(ListaDAVCabecalho.Items[0]).NomeDestinatario;
  NovoDAVCabecalho.CpfCnpjDestinatario := TDAVVO(ListaDAVCabecalho.Items[0]).CpfCnpjDestinatario;
  NovoDAVCabecalho.DataEmissao := FormatDateTime('yyyy-mm-dd', now);
  NovoDAVCabecalho.HoraEmissao := FormatDateTime('hh:nn:ss', now);
  NovoDAVCabecalho.Situacao := 'P';

  //atualiza a tabela de cabecalho
  for i := 0 to ListaDAVCabecalho.Count - 1 do
  begin
    //altera a situacao do DAV selecionado para M de mesclado
    ConsultaSQL :=
      'update ECF_DAV_CABECALHO set ' +
      'SITUACAO=:pSituacao '+
      ' where ID = :pId';

      try
        try
          Query := TSQLQuery.Create(nil);
          Query.SQLConnection := FDataModule.Conexao;
          Query.sql.Text := ConsultaSQL;
          Query.ParamByName('pId').AsInteger := TDAVVO(ListaDAVCabecalho.Items[i]).Id;
          Query.ParamByName('pSituacao').AsString := 'M';
          Query.ExecSQL();
        except
        end;
      finally
        Query.Free;
      end;
  end;

  //cria um novo dav
  ConsultaSQL :=
    'insert into ECF_DAV_CABECALHO (' +
    'NOME_DESTINATARIO,' +
    'CPF_CNPJ_DESTINATARIO,' +
    'DATA_EMISSAO,' +
    'HORA_EMISSAO,' +
    'SITUACAO) values (' +
    ':pDestinatario,' +
    ':pCPFCNPJ,' +
    ':pDataEmissao,' +
    ':pHoraEmissao,' +
    ':psituacao)';
  try
    try
      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;
      Query.ParamByName('pDestinatario').AsString := NovoDAVCabecalho.NomeDestinatario;
      Query.ParamByName('pCPFCNPJ').AsString := NovoDAVCabecalho.CpfCnpjDestinatario;
      Query.ParamByName('pDataEmissao').AsString := NovoDAVCabecalho.DataEmissao;
      Query.ParamByName('pHoraEmissao').AsString := NovoDAVCabecalho.HoraEmissao;
      Query.ParamByName('psituacao').AsString := NovoDAVCabecalho.Situacao;
      Query.ExecSQL();

      ConsultaSQL := 'select max(ID) as ID from ECF_DAV_CABECALHO';
      Query.sql.Text := ConsultaSQL;
      Query.Open();

      NovoDAVCabecalho.Id := Query.FieldByName('ID').AsInteger;
    except
    end;
  finally
    Query.Free;
  end;

  //atualiza a tabela de detalhes
  ConsultaSQL :=
    'insert into ECF_DAV_DETALHE (' +
    'ID_PRODUTO,' +
    'ID_ECF_DAV,' +
    'QUANTIDADE,' +
    'VALOR_UNITARIO,' +
    'VALOR_TOTAL) values (' +
    ':pIdProduto,' +
    ':pIdDav,' +
    ':pQuantidade,' +
    ':pValorUnitario,' +
    ':pValorTotal)';
  try
    try
      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;
      for i := 0 to ListaDAVDetalhe.Count - 1 do
      begin
        Query.ParamByName('pIdProduto').AsInteger := TDAVDetalheVO(ListaDAVDetalhe.Items[i]).IdProduto;
        Query.ParamByName('pIdDav').AsInteger := NovoDAVCabecalho.Id;
        Query.ParamByName('pQuantidade').AsFloat := TDAVDetalheVO(ListaDAVDetalhe.Items[i]).Quantidade;
        Query.ParamByName('pValorUnitario').AsFloat := TDAVDetalheVO(ListaDAVDetalhe.Items[i]).ValorUnitario;
        Query.ParamByName('pValorTotal').AsFloat := TDAVDetalheVO(ListaDAVDetalhe.Items[i]).ValorTotal;
        Query.ExecSQL();
      end;
    except
    end;
  finally
    Query.Free;
  end;
  FCaixa.FechaMenuOperacoes;
  FCaixa.CarregaDAV(IntToStr(NovoDAVCabecalho.Id));
end;

class function TDAVController.ListaDAVPeriodo(DataInicio:String; DataFim:String): TObjectList<TDAVVO>;
var
  ListaDAV: TObjectList<TDAVVO>;
  DAVCabecalho: TDAVVO;
  TotalRegistros: Integer;
begin
  //verifica se existe o DAV solicitado
  DataInicio := FormatDateTime('yyyy-mm-dd', StrToDate(DataInicio));
  DataFim := FormatDateTime('yyyy-mm-dd', StrToDate(DataFim));
  ConsultaSQL :=
    'select count(*) AS TOTAL from ECF_DAV_CABECALHO where SITUACAO =' + QuotedStr('E') +
    ' and (DATA_EMISSAO between ' +
    QuotedStr(DataInicio) + ' and ' + QuotedStr(DataFim) + ')';
  try
    try
      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;
      Query.Open;
      TotalRegistros := Query.FieldByName('TOTAL').AsInteger;

      if TotalRegistros > 0 then
      begin
        ListaDAV := TObjectList<TDAVVO>.Create;
        ConsultaSQL :=
          'select * from ECF_DAV_CABECALHO where SITUACAO = ' + QuotedStr('E') +
          ' and (DATA_EMISSAO between ' +
          QuotedStr(DataInicio) + ' and ' + QuotedStr(DataFim) + ')';
        Query.sql.Text := ConsultaSQL;
        Query.Open;
        Query.First;
        while not Query.Eof do
        begin
          DAVCabecalho := TDAVVO.Create;
          DAVCabecalho.Id := Query.FieldByName('ID').AsInteger;
          DAVCabecalho.DataEmissao := Query.FieldByName('DATA_EMISSAO').AsString;
          DAVCabecalho.HoraEmissao := Query.FieldByName('HORA_EMISSAO').AsString;
          DAVCabecalho.Valor := Query.FieldByName('VALOR').AsFloat;
          DAVCabecalho.CCF := Query.FieldByName('CCF').AsInteger;
          DAVCabecalho.COO := Query.FieldByName('COO').AsInteger;
          DAVCabecalho.Hash := Query.FieldByName('HASH_TRIPA').AsString;
          ListaDAV.Add(DAVCabecalho);
          Query.next;
        end;
        result := ListaDAV;
      end
      //caso não exista a relacao, retorna um ponteiro nulo
      else
        result := nil;
    except
      result := nil;
    end;
  finally
    Query.Free;
  end;
end;

class function TDAVController.ConsultaDAVId(Id:Integer): TDAVVO;
var
  DAVCabecalho: TDAVVO;
begin
  ConsultaSQL :=
    'select * from ECF_DAV_CABECALHO where ID = ' + IntToStr(Id);

  try
    try
      Query := TSQLQuery.Create(nil);
      Query.SQLConnection := FDataModule.Conexao;
      Query.sql.Text := ConsultaSQL;
      Query.Open;
      Query.First;

      DAVCabecalho := TDAVVO.Create;

      DAVCabecalho.Id := Query.FieldByName('ID').AsInteger;
      DAVCabecalho.DataEmissao := Query.FieldByName('DATA_EMISSAO').AsString;
      DAVCabecalho.HoraEmissao := Query.FieldByName('HORA_EMISSAO').AsString;
      DAVCabecalho.Valor := Query.FieldByName('VALOR').AsFloat;
      DAVCabecalho.CCF := Query.FieldByName('CCF').AsInteger;
      DAVCabecalho.COO := Query.FieldByName('COO').AsInteger;

      result := DAVCabecalho;
    except
      result := nil;
    end;
  finally
    Query.Free;
  end;

end;


end.
