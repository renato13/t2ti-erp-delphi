{*******************************************************************************
Title: T2Ti ERP
Description: VO da pre-venda.

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
unit PreVendaVO;

interface

type
  TPreVendaVO = class
  private
    FID: Integer;
    FID_CLIENTE: Integer;
    FCPF_CNPJ_DESTINATARIO: String;
    FNOME_DESTINATARIO: String;
    FDATA_PV: String;
    FHORA_PV: String;
    FSITUACAO: String;
    FCCF: Integer;
    FACRESCIMO: Extended;
    FDESCONTO: Extended;
    FTAXA_ACRESCIMO: Extended;
    FTAXA_DESCONTO: Extended;
    FSUBTOTAL: Extended;
    FVALOR: Extended;



  published

    property Id: Integer read FID write FID;
    property IdCliente: Integer read FID_CLIENTE write FID_CLIENTE;
    property NomeDestinatario: String read FNOME_DESTINATARIO write FNOME_DESTINATARIO;
    property CpfCnpjDestinatario: String read FCPF_CNPJ_DESTINATARIO write FCPF_CNPJ_DESTINATARIO;
    property DataEmissao: String read FDATA_PV write FDATA_PV;
    property HoraEmissao: String read FHORA_PV write FHORA_PV;
    property Situacao: String read FSITUACAO write FSITUACAO;
    property CCF: Integer read FCCF write FCCF;
    property SubTotal: Extended read FSUBTOTAL write FSUBTOTAL;
    property TaxaDesconto: Extended read FTAXA_DESCONTO write FTAXA_DESCONTO;
    property Desconto: Extended read FDESCONTO write FDESCONTO;
    property TaxaAcrescimo: Extended read FTAXA_ACRESCIMO write FTAXA_ACRESCIMO;
    property Acrescimo: Extended read FACRESCIMO write FACRESCIMO;
    property Valor: Extended read FVALOR write FVALOR;

end;

implementation

end.