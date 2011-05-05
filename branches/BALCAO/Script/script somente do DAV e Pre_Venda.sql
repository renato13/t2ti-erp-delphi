/*Table structure for table `ecf_dav_cabecalho` */

DROP TABLE IF EXISTS `ecf_dav_cabecalho`;

CREATE TABLE `ecf_dav_cabecalho` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ID_EMPRESA` int(10) unsigned NOT NULL,
  `ID_CLIENTE` int(10) unsigned NOT NULL,
  `CCF` int(10) unsigned DEFAULT NULL,
  `COO` int(10) unsigned DEFAULT NULL,
  `NOME_DESTINATARIO` varchar(100) DEFAULT NULL,
  `CPF_CNPJ_DESTINATARIO` varchar(14) DEFAULT NULL,
  `DATA_EMISSAO` date DEFAULT NULL,
  `HORA_EMISSAO` varchar(8) DEFAULT NULL,
  `SITUACAO` char(1) DEFAULT NULL,  
  `SUBTOTAL` decimal(20,6) DEFAULT NULL,
  `DESCONTO` decimal(20,6) DEFAULT NULL,
  `ACRESCIMO` decimal(20,6) DEFAULT NULL,  
  `VALOR` decimal(20,6) DEFAULT NULL,
  `HASH_TRIPA` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/*Table structure for table `ecf_dav_detalhe` */

DROP TABLE IF EXISTS `ecf_dav_detalhe`;

CREATE TABLE `ecf_dav_detalhe` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ID_PRODUTO` int(10) unsigned NOT NULL,
  `ID_ECF_DAV` int(10) unsigned NOT NULL,
  `ITEM` int(10) unsigned NOT NULL,
  `QUANTIDADE` decimal(20,6) DEFAULT NULL,
  `VALOR_UNITARIO` decimal(20,6) DEFAULT NULL,
  `VALOR_TOTAL` decimal(20,6) DEFAULT NULL,
  `CANCELADO` char(1) DEFAULT NULL,  
  `MESCLA_PRODUTO` char(1) DEFAULT 'N',
  PRIMARY KEY (`ID`),
  KEY `FK_DAV_CAB_DET` (`ID_ECF_DAV`),
  KEY `FK_PRODUTO_DAV_DET` (`ID_PRODUTO`),
  CONSTRAINT `ecf_dav_detalhe_ibfk_1` FOREIGN KEY (`ID_ECF_DAV`) REFERENCES `ecf_dav_cabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ecf_dav_detalhe_ibfk_2` FOREIGN KEY (`ID_PRODUTO`) REFERENCES `produto` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


/*Table structure for table `ecf_pre_venda_cabecalho` */

DROP TABLE IF EXISTS `ecf_pre_venda_cabecalho`;

CREATE TABLE `ecf_pre_venda_cabecalho` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ID_CLIENTE` int(10) unsigned NOT NULL,
  `NOME_DESTINATARIO` varchar(100) DEFAULT NULL,
  `CPF_CNPJ_DESTINATARIO` varchar(14) DEFAULT NULL,
  `DATA_PV` date DEFAULT NULL,
  `HORA_PV` varchar(8) DEFAULT NULL,
  `SITUACAO` char(1) DEFAULT NULL,
  `CCF` int(10) unsigned DEFAULT NULL,
  `SUBTOTAL` decimal(20,6) DEFAULT NULL,
  `DESCONTO` decimal(20,6) DEFAULT NULL,
  `ACRESCIMO` decimal(20,6) DEFAULT NULL, 
  `VALOR` decimal(20,6) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `ecf_pre_venda_detalhe` */

DROP TABLE IF EXISTS `ecf_pre_venda_detalhe`;

CREATE TABLE `ecf_pre_venda_detalhe` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ID_PRODUTO` int(10) unsigned NOT NULL,
  `ITEM` int(10) unsigned NOT NULL,
  `ID_ECF_PRE_VENDA_CABECALHO` int(10) unsigned NOT NULL,  
  `QUANTIDADE` decimal(20,6) DEFAULT NULL,
  `VALOR_UNITARIO` decimal(20,6) DEFAULT NULL,
  `VALOR_TOTAL` decimal(20,6) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `FK_PV_CAB_DET` (`ID_ECF_PRE_VENDA_CABECALHO`),
  KEY `FK_PRODUTO_PV_DET` (`ID_PRODUTO`),
  CONSTRAINT `ecf_pre_venda_detalhe_ibfk_1` FOREIGN KEY (`ID_ECF_PRE_VENDA_CABECALHO`) REFERENCES `ecf_pre_venda_cabecalho` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ecf_pre_venda_detalhe_ibfk_2` FOREIGN KEY (`ID_PRODUTO`) REFERENCES `produto` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
