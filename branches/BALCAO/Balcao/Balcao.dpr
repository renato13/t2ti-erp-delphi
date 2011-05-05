program Balcao;

uses
  Forms,
  UDataModule in 'UDataModule.pas' {FDataModule: TDataModule},
  ULogin in 'ULogin.pas' {FLogin},
  UMenu in 'UMenu.pas' {FMenu},
  UDAV in 'UDAV.pas' {FDAV},
  UImportaProduto in 'UImportaProduto.pas' {FImportaProduto},
  Biblioteca in '..\Biblioteca.pas',
  DAVDetalheVO in '..\VO\DAVDetalheVO.pas',
  DAVVO in '..\VO\DAVVO.pas',
  UNF2 in 'UNF2.pas' {FNF2},
  UPreVenda in 'UPreVenda.pas' {FPreVenda},
  PreVendaVO in '..\VO\PreVendaVO.pas',
  PreVendaDetalheVO in '..\VO\PreVendaDetalheVO.pas',
  ProdutoVO in '..\VO\ProdutoVO.pas',
  Constantes in '..\Constantes.pas',
  ClienteVO in '..\VO\ClienteVO.pas',
  UProcuraCliente in '..\UProcuraCliente.pas' {FProcuraCliente},
  PreVendaController in 'Controller\PreVendaController.pas',
  ProdutoController in 'Controller\ProdutoController.pas',
  ClienteController in 'Controller\ClienteController.pas',
  DAVController in 'Controller\DAVController.pas',
  OperadorController in 'Controller\OperadorController.pas',
  OperadorVO in '..\VO\OperadorVO.pas',
  UDescontoAcrescimo in 'UDescontoAcrescimo.pas' {FDescontoAcrescimo},
  ULoginGerenteSupervisor in 'ULoginGerenteSupervisor.pas' {FLoginGerenteSupervisor},
  ConexaoBD in 'Conexão\ConexaoBD.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFMenu, FMenu);
  Application.CreateForm(TFDataModule, FDataModule);
  Application.CreateForm(TFLogin, FLogin);
  FMenu.Show;
  FLogin.ShowModal;
  Application.Run;
end.
