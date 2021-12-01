#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 04/04/01

User Function NFINPRIO()

#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
 
//±±³Programa  ³  Nfiscal ³ Autor ³   Nadia C.C.Mamude    ³ Data ³ 10/04/01 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ Nota Fiscal de Entrada/Saida                               ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Ambientais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Nota Fiscal                       ³
//³ mv_par02             // Ate a Nota Fiscal                    ³
//³ mv_par03             // Da Serie                             ³
//³ mv_par04             // Nota Fiscal de Entrada/Saida         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
CbTxt    := ""
CbCont   := ""
nOrdem   := 0
Alfa     := 0
Z        := 0
M        := 0
tamanho  := "P"
limite   := 80
titulo   := PADC("Nota Fiscal - Nfiscal",74)
cDesc1   := PADC("Este programa ira emitir a Nota Fiscal de Entrada/Saida.",74)
cDesc2   := ""
cDesc3   := PADC("",74)
cNatureza:= ""
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog := "nfiscal"
cPerg    := PadR("NFSIGW",Len(SX1->X1_GRUPO))
nLastKey := 0
lContinua:= .T.
nLin     := 0
wnrel    := "SIGANF"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tamanho do Formulario de Nota Fiscal (em Linhas)          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nTamNf   := 72    // Apenas Informativo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.f.)               // Pergunta no SX1

cString  := "SF2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica Posicao do Formulario na Impressora                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
setprc(0,0)
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

VerImp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³ Inicio do Processamento da Nota Fiscal                       ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF WINDOWS
	RptStatus({|| RptDetail()})
	Return
	Static Function RptDetail()
#ENDIF

If mv_par04 == 2
	dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial("SF2")+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial("SD2")+mv_par01+mv_par03)
	cPedant := SD2->D2_PEDIDO
Else
	dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial("SF1")+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa  regua de impressao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(Val(mv_par02)-Val(mv_par01))

If mv_par04 == 2
	
	dbSelectArea("SF2")
	
	While !eof() .and. SF2->F2_DOC <= mv_par02 .and. SF2->F2_DOC >= MV_PAR01 .and. lContinua
		
		If SF2->F2_SERIE # mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		
		#IFNDEF WINDOWS
			IF LastKey()==286
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ELSE
			IF lAbortPrint
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ENDIF
		
		// Serafim
		
		nLinIni := nLin                         // Linha Inicial da Impressao
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Inicio de Levantamento dos Dados da Nota Fiscal de saida     ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Cabecalho da Nota Fiscal
		*/
		xNUM_NF     := SF2->F2_DOC             // Numero
		xSERIE      := SF2->F2_SERIE           // Serie
		xEMISSAO    := SF2->F2_EMISSAO         // Data de Emissao
		xTOT_FAT    := SF2->F2_VALFAT          // Valor Total da Fatura
		
		If xTOT_FAT == 0
			xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+;
			SF2->F2_SEGURO+SF2->F2_FRETE
		Endif
		
		xLOJA       := SF2->F2_LOJA            // Loja do Cliente
		xFRETE      := SF2->F2_FRETE           // Frete
		xSEGURO     := SF2->F2_SEGURO          // Seguro
		xBASE_ICMS  := SF2->F2_BASEICM         // Base   do ICMS
		xBASE_IPI   := SF2->F2_BASEIPI         // Base   do IPI
		xVALOR_ICMS := SF2->F2_VALICM          // Valor  do ICMS
		xICMS_RET   := SF2->F2_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  := SF2->F2_VALIPI          // Valor  do IPI
		xVALOR_MERC := SF2->F2_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC := SF2->F2_DUPL            // Numero da Duplicata
		xCOND_PAG   := SF2->F2_COND            // Condicao de Pagamento
		xPBRUTO     := SF2->F2_PBRUTO          // Peso Bruto
		xPLIQUI     := SF2->F2_PLIQUI          // Peso Liquido
		xTIPO       := SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE    := SF2->F2_ESPECI1         // Especie 1 no Pedido
		xVOLUME     := SF2->F2_VOLUME1         // Volume 1 no Pedido
		xIRRF       := SF2->F2_VALIRRF         // VALOR DO IRRF

      _nValPis    := 0
      _nValCof    := 0
      _nValCsl    := 0
      
      dbSelectArea("SE1")
      dbSetOrder(1)
      dbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC)
      Do While !eof() .and. SF2->F2_SERIE == SE1->E1_PREFIXO .and. SF2->F2_DOC == SE1->E1_NUM
         If     SE1->E1_TIPO == "PI-"
                _nValPis := SE1->E1_VALOR
         ElseIf SE1->E1_TIPO == "CF-"
                _nValCof := SE1->E1_VALOR
         ElseIf SE1->E1_TIPO == "CS-"
                _nValCsl := SE1->E1_VALOR
         EndIf
         dbSkip()       
      EndDo
      xValImp := _nValPis + _nValCof + _nValCsl      // Valor do PIS/COFINS/CSLL

//      xValCsll    := (SF2->F2_VALIMP5 * 0.01) / 0.03
//      xValImp     :=  SF2->F2_VALIMP5 + SF2->F2_VALIMP6 + xValCsll
//		xValImp     :=  SF2->F2_VALCSLL + SF2->F2_VALCOFI + SF2->F2_VALPIS
//		xValImp     := (SF2->F2_VALCOFI+SF2->F2_VALPIS+SF2->F2_VALCSLL)
//		xValImp     := U_V10925fin(SF2->F2_SERIE,SF2->F2_DOC,SF2->F2_CLIENTE,SF2->F2_LOJA,SF2->F2_EMISSAO)
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Variaveis para os itens da nota fiscal                       ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		xPED_VEND:= {}            // Numero do Pedido de Venda
		xITEM_PED:= {}            // Numero do Item do Pedido de Venda
		xNUM_NFDV:= {}            // nUMERO QUANDO HOUVER DEVOLUCAO
		xPREF_DV := {}            // Serie  quando houver devolucao
		xICMS    := {}            // Porcentagem do ICMS
		xCOD_PRO := {}            // Codigo  do Produto
		xQTD_PRO := {}            // Peso/Quantidade do Produto
		xPRE_UNI := {}            // Preco Unitario de Venda
		xPRE_TAB := {}            // Preco Unitario de Tabela
		xIPI     := {}            // Porcentagem do IPI
		xVAL_IPI := {}            // Valor do IPI
		xDESC    := {}            // Desconto por Item
		xVAL_DESC:= {}            // Valor do Desconto
		xVAL_MERC:= {}            // Valor da Mercadoria
		xTES     := {}            // TES
		xCF      := {}            // Classificacao quanto natureza da Operacao
		xICMSOL  := {}            // Base do ICMS Solidario
		xICM_PROD:= {}            // ICMS do Produto
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Loop que controla a quebra de nota fiscal                    ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		dbSelectArea("SD2")
		dbSetOrder(3)
		dbSeek(xFilial("SD2")+xNUM_NF+xSERIE)
		
		cPedAtu  := SD2->D2_PEDIDO
		cItemAtu := SD2->D2_ITEMPV
		
		while !eof() .and. SD2->D2_DOC   == xNUM_NF;
			.and. SD2->D2_SERIE == xSERIE
			
			If SD2->D2_SERIE # mv_par03
				DbSkip()
				Loop
			Endif
			
			AADD(xPED_VEND ,SD2->D2_PEDIDO)
			AADD(xITEM_PED ,SD2->D2_ITEMPV)
			AADD(xNUM_NFDV ,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
			AADD(xPREF_DV  ,SD2->D2_SERIORI)
			AADD(xICMS     ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			AADD(xCOD_PRO  ,SD2->D2_COD)
			AADD(xQTD_PRO  ,SD2->D2_QUANT)
			AADD(xPRE_UNI  ,SD2->D2_PRCVEN)
			AADD(xPRE_TAB  ,SD2->D2_PRUNIT)
			AADD(xIPI      ,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
			AADD(xVAL_IPI  ,SD2->D2_VALIPI)
			AADD(xDESC     ,SD2->D2_DESC)
			AADD(xVAL_MERC ,SD2->D2_TOTAL)
			AADD(xTES      ,SD2->D2_TES)
			AADD(xCF       ,SD2->D2_CF)
			AADD(xICM_PROD ,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			
			dbskip()
			Loop
			
		EndDo
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Carrega variaveis com os dados do cadastro de produtos       ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		xPESO_PRO := {}                  // Peso Liquido
		xPESO_UNIT:= {}                  // Peso Unitario do Produto
		xDESCRICAO:= {}                  // Descricao do Produto
		xUNID_PRO := {}                  // Unidade do Produto
		xCOD_TRIB := {}                  // Codigo de Tributacao
		xMEN_TRIB := {}                  // Mensagens de Tributacao
		xCOD_FIS  := {}                  // Cogigo Fiscal
		xCLAS_FIS := {}                  // Classificacao Fiscal
		xMEN_POS  := {}                  // Mensagem da Posicao IPI
		xISS      := {}                  // Aliquota de ISS
		xTIPO_PRO := {}                  // Tipo do Produto
		xLUCRO    := {}                  // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL := {}
		xPESO_LIQ := 0
		I := 1
		
		While I <= Len(xCOD_PRO)
			
			dbSelectArea("SB1")              // * Desc. Generica do Produto
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+xCOD_PRO[I])
			
			AADD(xPESO_PRO ,SB1->B1_PESO * xQTD_PRO[I])
			
			xPESO_LIQ  := xPESO_LIQ + xPESO_PRO[I]
			
			AADD(xPESO_UNIT,SB1->B1_PESO)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xDESCRICAO,SB1->B1_DESC)
			
			AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
			
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM) == 0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			If npElem == 0
				AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
			Endif
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			DO CASE
				CASE npElem == 1
					_CLASFIS := "A"
				CASE npElem == 2
					_CLASFIS := "B"
				CASE npElem == 3
					_CLASFIS := "C"
				CASE npElem == 4
					_CLASFIS := "D"
				CASE npElem == 5
					_CLASFIS := "E"
				CASE npElem == 6
					_CLASFIS := "F"
			ENDCASE
			
			nPteste := Ascan(xCLFISCAL,_CLASFIS)
			
			If nPteste == 0
				AADD(xCLFISCAL,_CLASFIS)
			Endif
			
			AADD(xCOD_FIS ,_CLASFIS)
			
			If SB1->B1_ALIQISS > 0
				AADD(xISS ,SB1->B1_ALIQISS)
			Endif
			
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			xPESO_LIQUID := 0
			
			For Z := 1 to Len(xPESO_PRO)
				xPESO_LIQUID := xPESO_LIQUID+xPESO_PRO[Z]
			Next
			
			I := I + 1
			
		EndDo
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Carrega variaveis com os dados do pedido de venda a imprimir ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		dbSelectArea("SC5")
		dbSetOrder(1)
		
		xPED        := {}
		xPESO_BRUTO := 0
		xP_LIQ_PED  := 0
		
		For I := 1 to Len(xPED_VEND)
			
			dbSeek(xFilial("SC5")+xPED_VEND[I])
			
			If ASCAN(xPED,xPED_VEND[I]) == 0
				
				xPED_NOTA  := SC5->C5_NUM
				xCLIENTE   := SC5->C5_CLIENTE            // Codigo do Cliente
				xTIPO_CLI  := SC5->C5_TIPOCLI            // Tipo de Cliente
				xCOD_MENS  := SC5->C5_MENPAD             // Codigo da Mensagem Padrao
				xMENSAGEM  := SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
				xTPFRETE   := SC5->C5_TPFRETE            // Tipo de Entrega
				xPESO_BRUTO:= SC5->C5_PBRUTO             // Peso Bruto
				xP_LIQ_PED := xP_LIQ_PED + SC5->C5_PESOL // Peso Liquido
				xCOD_VEND  := {SC5->C5_VEND1,;           // Codigo do Vendedor 1
				SC5->C5_VEND2,;           // Codigo do Vendedor 2
				SC5->C5_VEND3,;           // Codigo do Vendedor 3
				SC5->C5_VEND4,;           // Codigo do Vendedor 4
				SC5->C5_VEND5}            // Codigo do Vendedor 5
				xDESC_NF   := {SC5->C5_DESC1,;           // Desconto Global 1
				SC5->C5_DESC2,;           // Desconto Global 2
				SC5->C5_DESC3,;           // Desconto Global 3
				SC5->C5_DESC4}            // Desconto Global 4
				
				AADD(xPED,xPED_VEND[I])
				
			Endif
			
			If xP_LIQ_PED > 0
				xPESO_LIQ := xP_LIQ_PED
			Endif
			
		Next
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Pesquisa da Condicao de Pagto                                ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		//dbSeek(xFilial("SE4")+xCONDPAG)
		
		xDESC_PAG := SE4->E4_DESCRI
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa da Forma de Pagto                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		
		dbSelectArea("SC6")                    // * Itens de Pedido de Venda
		dbSetOrder(1)
		
		xPED_CLI  := {}                        // Numero de Pedido
		xDESC_PRO := {}                        // Descricao aux do produto
		xCONTDESCR:= {}                       // Continuacao da Descricao do Produto
		
		J := Len(xPED_VEND)
		
		For I := 1 to J
			
			dbSeek(xFilial("SC6")+xPED_VEND[I]+xITEM_PED[I])
			
			AADD(xPED_CLI ,SC6->C6_PEDCLI)
			AADD(xDESC_PRO,SC6->C6_DESCRI)
			AADD(xVAL_DESC,SC6->C6_VALDESC)
			//       	AADD(xCONTDESCR,SC6->C6_CONDESC)
		Next
		
		If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR.;
			xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'
			
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+xCLIENTE+xLOJA)
			
			xCOD_CLI :=SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI:=SA1->A1_NOME            // Nome
			xEND_CLI :=SA1->A1_END             // Endereco
			xBAIRRO  :=SA1->A1_BAIRRO          // Bairro
			xCEP_CLI :=SA1->A1_CEP             // CEP
			xMUN_CLI :=SA1->A1_MUN             // Municipio
			xEST_CLI :=SA1->A1_EST             // Estado
			xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			xSUFRAMA :=SA1->A1_SUFRAMA         // Codigo Suframa
			xCALCSUF :=SA1->A1_CALCSUF         // Calcula Suframa
			xNATUREZ :=SA1->A1_NATUREZ         // Verifica a Natureza para calculo do IRF
			xPerIRF := " "
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Alteracao p/ Calculo de Suframa                              ³
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			*/
			If !empty(xSUFRAMA) .and. xCALCSUF =="S"
				If XTIPO == 'D' .OR. XTIPO == 'B'
					zFranca := .F.
				Else
					zFranca := .T.
				Endif
			Else
				zfranca := .F.
			Endif
			
		Else
			
			zFranca:=.F.
			
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+xCLIENTE+xLOJA)
			
			xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
			xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
			xEND_CLI :=iif(!Empty(xENDCOMP),xENDCOMP,SA2->A2_END)       // Endereco
			xBAIRRO  :=iif(!Empty(xBAICOMP),xBAICOMP,SA2->A2_BAIRRO)    // Bairro
			xCEP_CLI :=iif(!Empty(xCEPCOMP),xCEPCOMP,SA2->A2_CEP)       // CEP
			xMUN_CLI :=iif(!Empty(xMUNCOMP),xMUNCOMP,SA2->A2_MUN)       // Municipio
			xEST_CLI :=iif(!Empty(xESTCOMP),xESTCOMP,SA2->A2_EST)       // Estado
			xCOB_CLI :=""                      // Endereco de Cobranca
			xREC_CLI :=""                      // Endereco de Entrega
			xCGC_CLI :=SA2->A2_CGC             // CGC
			xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
			xTEL_CLI :=SA2->A2_TEL             // Telefone
			xFAX_CLI :=SA2->A2_FAX             // Fax
		Endif
		
		dbSelectArea("SA3")                    // * Cadastro de Vendedores
		dbSetOrder(1)
		
		xVENDEDOR := {}                         // Nome do Vendedor
		
		I := 1
		J := Len(xCOD_VEND)
		
		For I := 1 to J
			dbSeek(xFilial("SA3")+xCOD_VEND[I])
			Aadd(xVENDEDOR,SA3->A3_NREDUZ)
		Next
		
		If xICMS_RET >0                          // Apenas se ICMS Retido > 0
			dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
			dbSetOrder(4)
			dbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
			
			If Found()
				xBSICMRET:=F3_VALOBSE
			Else
				xBSICMRET:=0
			Endif
		Else
			xBSICMRET:=0
		Endif
		
		dbSelectArea("SA4")                   // * Transportadoras
		dbSetOrder(1)
		dbSeek(xFilial("SA4")+SF2->F2_TRANSP)
		
		xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
		xEND_TRANSP  :=SA4->A4_END            // Endereco
		xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
		xEST_TRANSP  :=SA4->A4_EST            // Estado
		xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
		xCGC_TRANSP  :=SA4->A4_CGC            // CGC
		xTEL_TRANSP  :=SA4->A4_TEL            // Fone
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVENC_DUP1 :={}                       // Vencimento REAL
		xVALOR_DUP :={}                       // Valor
		//		xIRRF      :={}
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Flag p/Impressao de Duplicatas                               ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		
		xDUPLICATAS:=IIF(dbSeek(xFilial("SE1")+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.)
		
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			If !("NF" $ SE1->E1_TIPO)
				dbSkip()
				Loop
			Endif
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVENC_DUP1,SE1->E1_VENCREA)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			
			dbSkip()
		EndDo
		
		
		dbSelectArea("SF4")                  // * Tipos de Entrada e Saida
		DbSetOrder(1)
		dbSeek(xFilial("SF4")+SD2->D2_TES)   //xTES[1])
		
		xNATUREZA := SF4->F4_TEXTO           // Natureza da Operacao
		
		Imprime()                            // Funcao de impressao da N.F.
		
		IncRegua()                          // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF2")
		dbSkip()                         // passa para a proxima Nota Fiscal
		
	EndDo
	
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Inicio do tratamento da nota fiscal de entradas              ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	*/
	
Else                                // Vai processar N.F. de entrada
	
	dbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	
	dbSeek(xFilial("SF1")+mv_par01+mv_par03,.t.)
	
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. SF2->F2_DOC >= MV_PAR01;
		.and. SF1->F1_SERIE == mv_par03;
		.and. lContinua
		
		If SF1->F1_SERIE # mv_par03    // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Inicializa  regua de impressao                            ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		SetRegua(Val(mv_par02)-Val(mv_par01))
		
		#IFNDEF WINDOWS
			IF LastKey()==286
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ELSE
			IF lAbortPrint
				@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
				lContinua := .F.
				Exit
			Endif
		#ENDIF
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Inicio de Levantamento dos Dados da Nota Fiscal              ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		*/
		xNUM_NF     :=SF1->F1_DOC             // Numero
		xSERIE      :=SF1->F1_SERIE           // Serie
		xFORNECE    :=SF1->F1_FORNECE         // Cliente/Fornecedor
		xEMISSAO    :=SF1->F1_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF1->F1_VALBRUT         // Valor Bruto da Compra
		xLOJA       :=SF1->F1_LOJA            // Loja do Cliente
		xFRETE      :=SF1->F1_FRETE           // Frete
		xSEGURO     :=SF1->F1_DESPESA         // Despesa
		xBASE_ICMS  :=SF1->F1_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF1->F1_BASEIPI         // Base   do IPI
		xBSICMRET   :=SF1->F1_BRICMS          // Base do ICMS Retido
		xVALOR_ICMS :=SF1->F1_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF1->F1_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF1->F1_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF1->F1_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF1->F1_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF1->F1_COND            // Condicao de Pagamento
		xTIPO       :=SF1->F1_TIPO            // Tipo do Cliente
		xNFORI      :=SF1->F1_NFORI           // NF Original
		xPREF_DV    :=SF1->F1_SERIORI         // Serie Original
		
		dbSelectArea("SD1")                   // * Itens da N.F. de Compra
		dbSetOrder(1)
		dbSeek(xFilial("SD1")+xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
		cPedAtu := SD1->D1_PEDIDO
		cItemAtu:= SD1->D1_ITEMPC
		
		xPEDIDO  :={}                         // Numero do Pedido de Compra
		xITEM_PED:={}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV:={}                         // Numero quando houver devolucao
		xPREF_DV :={}                         // Serie  quando houver devolucao
		xICMS    :={}                         // Porcentagem do ICMS
		xCOD_PRO :={}                         // Codigo  do Produto
		xQTD_PRO :={}                         // Peso/Quantidade do Produto
		xPRE_UNI :={}                         // Preco Unitario de Compra
		xIPI     :={}                         // Porcentagem do IPI
		xPESOPROD:={}                         // Peso do Produto
		xVAL_IPI :={}                         // Valor do IPI
		xDESC    :={}                         // Desconto por Item
		xVAL_DESC:={}                         // Valor do Desconto
		xVAL_MERC:={}                         // Valor da Mercadoria
		xTES     :={}                         // TES
		xCF      :={}                         // Classificacao quanto natureza da Operacao
		xICMSOL  :={}                         // Base do ICMS Solidario
		xICM_PROD:={}                         // ICMS do Produto
		
		while !eof() .and. SD1->D1_DOC==xNUM_NF
			If SD1->D1_SERIE # mv_par03        // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!
				Loop
			Endif
			
			AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
			AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
			AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
			AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
			AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(xCOD_PRO  ,SD1->D1_COD)            // Produto
			AADD(xQTD_PRO  ,SD1->D1_QUANT)          // Guarda as quant. da NF
			AADD(xPRE_UNI  ,SD1->D1_VUNIT)          // Valor Unitario
			AADD(xIPI      ,SD1->D1_IPI)            // % IPI
			AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI
			AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
			AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
			AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
			AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
			AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
			AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			dbskip()
		Enddo
		
		dbSelectArea("SB1")          // * Desc. Generica do Produto
		dbSetOrder(1)
		
		xUNID_PRO :={}               // Unidade do Produto
		xDESC_PRO :={}               // Descricao do Produto
		xMEN_POS  :={}               // Mensagem da Posicao IPI
		xDESCRICAO:={}               // Descricao do Produto
		xCOD_TRIB :={}               // Codigo de Tributacao
		xMEN_TRIB :={}               // Mensagens de Tributacao
		xCOD_FIS  :={}               // Cogigo Fiscal
		xCLAS_FIS :={}               // Classificacao Fiscal
		xISS      :={}               // Aliquota de ISS
		xTIPO_PRO :={}               // Tipo do Produto
		xLUCRO    :={}               // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL :={}
		xSUFRAMA  :=""
		xCALCSUF  :=""
		I:=1
		
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial("SB1")+xCOD_PRO[I])
			dbSelectArea("SB1")
			
			AADD(xDESC_PRO ,SB1->B1_DESC)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xCOD_TRIB ,SB1->B1_ORIGEM)
			
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			
			AADD(xDESCRICAO ,SB1->B1_DESC)
			AADD(xMEN_POS  ,SB1->B1_POSIPI)
			
			If SB1->B1_ALIQISS > 0
				AADD(xISS,SB1->B1_ALIQISS)
			Endif
			
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			If npElem == 0
				AADD(xCLAS_FIS  ,SB1->B1_POSIPI)
			Endif
			
			npElem := ascan(xCLAS_FIS,SB1->B1_POSIPI)
			
			DO CASE
				CASE npElem == 1
					_CLASFIS := "A"
				CASE npElem == 2
					_CLASFIS := "B"
				CASE npElem == 3
					_CLASFIS := "C"
				CASE npElem == 4
					_CLASFIS := "D"
				CASE npElem == 5
					_CLASFIS := "E"
				CASE npElem == 6
					_CLASFIS := "F"
					
			EndCase
			
			nPteste := Ascan(xCLFISCAL,_CLASFIS)
			
			If nPteste == 0
				AADD(xCLFISCAL,_CLASFIS)
			Endif
			
			AADD(xCOD_FIS ,_CLASFIS)
			
		Next
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa da Condicao de Pagto               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCOND_PAG)
		
		xDESC_PAG := SE4->E4_DESCRI
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pesquisa da Forma de Pagto                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SC5")
		dbSetOrder(1)
		
		If xTIPO == "D"
			
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial("SA1")+xFORNECE)
			
			xPED_NOTA := ""
			xCOD_CLI  := SA1->A1_COD             // Codigo do Cliente
			xNOME_CLI := SA1->A1_NOME            // Nome
			xEND_CLI :=iif(!Empty(xENDCOMP),xENDCOMP,SA1->A1_END)       // Endereco
			xBAIRRO  :=iif(!Empty(xBAICOMP),xBAICOMP,SA1->A1_BAIRRO)    // Bairro
			xCEP_CLI :=iif(!Empty(xCEPCOMP),xCEPCOMP,SA1->A1_CEP)       // CEP
			xMUN_CLI :=iif(!Empty(xMUNCOMP),xMUNCOMP,SA1->A1_MUN)       // Municipio
			xEST_CLI :=iif(!Empty(xESTCOMP),xESTCOMP,SA1->A1_EST)       // Estado
			xCOB_CLI :=SA1->A1_ENDCOB          // Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          // Endereco de Entrega
			xCGC_CLI :=SA1->A1_CGC             // CGC
			xINSC_CLI:=SA1->A1_INSCR           // Inscricao estadual
			xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			
		Else
			
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial("SA2")+xFORNECE+xLOJA)
			
			xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
			xNOME_CLI:=SA2->A2_NOME               // Nome
			
			xEND_CLI :=iif(!Empty(xENDCOMP),xENDCOMP,SA2->A2_END)       // Endereco
			xBAIRRO  :=iif(!Empty(xBAICOMP),xBAICOMP,SA2->A2_BAIRRO)    // Bairro
			xCEP_CLI :=iif(!Empty(xCEPCOMP),xCEPCOMP,SA2->A2_CEP)       // CEP
			xMUN_CLI :=iif(!Empty(xMUNCOMP),xMUNCOMP,SA2->A2_MUN)       // Municipio
			xEST_CLI :=iif(!Empty(xESTCOMP),xESTCOMP,SA2->A2_EST)       // Estado
			xCOB_CLI :=""                         // Endereco de Cobranca
			xREC_CLI :=""                         // Endereco de Entrega
			xCGC_CLI :=SA2->A2_CGC                // CGC
			xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
			xTRAN_CLI:=SA2->A2_TRANSP             // Transportadora
			xTEL_CLI :=SA2->A2_TEL                // Telefone
			xFAX     :=SA2->A2_FAX                // Fax
			
		EndIf
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVENC_DUP1 :=SE1->E1_VENCREA          // Vencimento Real
		xVALOR_DUP :={}                       // Valor
		
		// Flag p/Impressao de Duplicatas
		xDUPLICATAS:=IIF(dbSeek(xFilial("SE1")+xSERIE+xNUM_DUPLIC,.T.),.T.,.F.)
		
		while !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP1 ,SE1->E1_VENCREA)
			AADD(xVALOR_DUP,SE1->E1_VALOR)
			
			dbSkip()
		EndDo
		
		dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
		dbSetOrder(1)
		dbSeek(xFilial("SF4")+SD1->D1_TES)
		
		xNATUREZA:=SF4->F4_TEXTO              // Natureza da Operacao
		
		xNOME_TRANSP :=" "           // Nome Transportadora
		xEND_TRANSP  :=" "           // Endereco
		xMUN_TRANSP  :=" "           // Municipio
		xEST_TRANSP  :=" "           // Estado
		xVIA_TRANSP  :=" "           // Via de Transporte
		xCGC_TRANSP  :=" "           // CGC
		xTEL_TRANSP  :=" "           // Fone
		xTPFRETE     :=" "           // Tipo de Frete
		xVOLUME      := 0            // Volume
		xESPECIE     :=" "           // Especie
		xPESO_LIQ    := 0            // Peso Liquido
		xPESO_BRUTO  := 0            // Peso Bruto
		xCOD_MENS    :=" "           // Codigo da Mensagem
		xMENSAGEM    :=" "           // Mensagem da Nota
		xPESO_LIQUID :=" "
		
		Imprime()
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
		
	EndDo
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                      FIM DA IMPRESSAO                        ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fechamento do Programa da Nota Fiscal                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")
Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim do Programa                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³                   FUNCOES ESPECIFICAS                        ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ VERIMP   ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica posicionamento de papel na Impressora             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function VerImp

nLin:= 0                // Contador de Linhas
nLinIni:=0
If aReturn[5]==2
	
	nOpc       := 1
	#IFNDEF WINDOWS
		cCor       := "B/BG"
	#ENDIF
	While .T.
		
		SetPrc(0,0)
		@PROW(),PCOL() SAY CHR(18)
		@ PROW(),PCOL() SAY CHR(15)
		dbCommitAll()
		
		@ nLin ,000 PSAY " "
		*@ nLin ,039 PSAY "*"     //004
		*@ nLin ,022 PSAY "."
		#IFNDEF WINDOWS
			Set Device to Screen
			DrawAdvWindow(" Formulario ",10,25,14,56)
			SetColor(cCor)
			@ 12,27 Say "Formulario esta posicionado?"
			nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
			Set Device to Print
		#ELSE
			IF MsgYesNo("Fomulario esta posicionado ? ")
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
		#ENDIF
		
		Do Case
			Case nOpc==1
				lContinua:=.T.
				Exit
			Case nOpc==2
				Loop
			Case nOpc==3
				lContinua:=.F.
				Return
		EndCase
	End
Endif

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPDET   ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Linhas de Detalhe da Nota Fiscal              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function IMPDET

nTamDet := 10            // Tamanho da Area de Detalhe

I := 1
//J:=1
xB_ICMS_SOL:=0          // Base  do ICMS Solidario
xV_ICMS_SOL:=0          // Valor do ICMS Solidario

For I := 1 to nTamDet
	If I <= Len(xCOD_PRO)
		
		@ nLin ,027 PSAY xDESCRICAO[I]
//		@ nLin, 100  PSAY xPRE_UNI[I]        Picture"@E 99,999,999.99"
		@ nLin, 108 PSAY xVAL_MERC[I]       Picture "@E 99,999,999.99"
		nLin := nLin + 1
		IF !EMPTY(xNATUREZ)
		    DBSELECTAREA("SED")
		    SED->(DBSEEK(xFILIAL("SED")+xNATUREZ))
		    xPerIRF := ALLTRIM(STR(SED->ED_PERCIRF))
		ENDIF
		If xEst_CLi <> "EX"
				If xIRRF > 10
					@ nLin, 027 PSAY "IR RETIDO NA FONTE "
					@ nLin, 046 PSAY xPerIrf Picture "@E 9.99"
					@ nLin, 050 PSAY "%"
					@ nLin, 070 PSAY xIRRF Picture "@E 99,999.99"
					nLin := nLin + 1
				EndIf
		      IF xValImp > 0
				   @ nLin, 027 PSAY "CSLL/PIS/COFINS RETIDO NA FONTE 4,65%"
				   @ nLin, 070 PSAY xValImp Picture "@E 99,999.99"
				ENDIF   
		EndIf
		
		nLin := nLin + 1
		
		WMENS := ALLTRIM(xMENSAGEM)
		@ nLin , 027 PSAY SUBSTR(WMENS,1,60) //MEMOLINE(WMENS,60,1,,.T.)
		
//		IF !EMPTY(MEMOLINE(WMENS,60,2,,.T.))
//			nLin := nLin + 1
//			@ nLin , 027 PSAY MEMOLINE(WMENS,60,2,,.T.)
//		ENDIF
		
//		IF !EMPTY(MEMOLINE(WMENS,60,3,,.T.))
//			nLin := nLin + 1
//			@ nLin , 027 PSAY MEMOLINE(WMENS,60,3,,.T.)
//		ENDIF
		
//		IF !EMPTY(MEMOLINE(WMENS,60,4,,.T.))
//			nLin := nLin + 1
//			@ nLin , 027 PSAY MEMOLINE(WMENS,60,4,,.T.)
//		ENDIF
		
//		IF !EMPTY(MEMOLINE(WMENS,60,5,,.T.))
//			nLin := nLin + 1
//			@ nLin , 027 PSAY MEMOLINE(WMENS,60,5,,.T.)
//		ENDIF
      nLin := nLin + 1		
	Endif
	nLin := nLin + 1
Next

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CLASFIS  ³ Autor ³   Marcos Simidu       ³ Data ³ 16/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Array com as Classificacoes Fiscais           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function CLASFIS

// @ nLin,006 PSAY "Classificacao Fiscal"
nLin := nLin + 1
For nCont := 1 to Len(xCLFISCAL) .And. nCont <= 12
	nCol := If(Mod(nCont,2) != 0, 06, 33)
	//   @ nLin, nCol   PSAY xCLFISCAL[nCont] + "-"
	//   @ nLin, nCol+ 05 PSAY Transform(xCLAS_FIS[nCont],"@r 99.99.99.99.99")
	nLin := nLin + If(Mod(nCont,2) != 0, 0, 1)
Next

Return

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPMENP  ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Mensagem Padrao da Nota Fiscal                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function IMPMENP

nCol:= 05    //05

If !Empty(xCOD_MENS)
	
	@ nLin, NCol PSAY FORMULA(xCOD_MENS)
	
Endif

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MENSOBS  ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Mensagem no Campo Observacao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function MENSOBS

// @ 28, 20 PSAY UPPER(xMENSAGEM)    //39,2

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ DUPLIC   ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao do Parcelamento das Duplicacatas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Nfiscal                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function DUPLIC

nCol := 071
nAjuste := 0
For BB:= 1 to Len(xVALOR_DUP)
	@ nLin, nCol PSAY xVENC_DUP1[BB]
	nAjuste := nAjuste + 50
Next

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LI       ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pula 1 linha                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico RDMAKE                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Funcao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Funcao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IMPRIME  ³ Autor ³   Marcos Simidu       ³ Data ³ 20/12/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime a Nota Fiscal de Entrada e de Saida                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico RDMAKE                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
*/

Static Function Imprime

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                              ³
//³              IMPRESSAO DA N.F. DA Nfiscal                    ³
//³                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do Cabecalho da N.F.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if(aReturn[5]==1) // Visualiza
	nDPort:=0
endif
if(aReturn[5]==3) // Direto na porta
	nDPort:=1
endif
SetPrc(0,0)
//@ 02, 000 PSAY Chr(15)                // Compressao de Impressao
// Se o usuário escolheu imprimir direto na porta impimir linha+1 else linha+0
@ 01+nDPort, 000 PSAY Chr(15)

/// @ 02, 146 PSAY xNUM_NF                // Numero da Nota Fiscal

///If mv_par04 == 1
///   @ 03, 120 PSAY "X"
///Else
///   @ 03, 108 PSAY "X"
///Endif

//@ 05, 065 PSAY "ASSES.IMPRENSA"
//@ 07, 065 PSAY xEMISSAO                   // Data da Emissao do Documento
//@ 10, 017 PSAY xNOME_CLI                 // Nome do Cliente
@ 02+nDPort, 100 PSAY xNUM_NF
@ 04+nDPort, 065 PSAY "ASSES.IMPRENSA"
@ 06+nDPort, 065 PSAY xEMISSAO                   // Data da Emissao do Documento
@ 09+nDPort, 017 PSAY xNOME_CLI                 // Nome do Cliente
If !EMPTY(xCGC_CLI)                 // Se o C.G.C. do Cli/Forn = nao Vazio
//	@ 10, 104 PSAY xCGC_CLI Picture "@R 99.999.999/9999-99"
	@ 09+nDPort, 104 PSAY xCGC_CLI Picture "@R 99.999.999/9999-99"
Else
//	@ 10, 104 PSAY " "                   // Caso seja vazio
	@ 09+nDPort, 104 PSAY " "                   // Caso seja vazio
Endif
//@ 11, 017 PSAY xEND_CLI                 // Endereco
//@ 11, 104 PSAY xINSC_CLI                                // Insc. Estadual
@ 10+nDPort, 017 PSAY xEND_CLI                 // Endereco
@ 10+nDPort, 104 PSAY xINSC_CLI                                // Insc. Estadual

///@ 15, 086 PSAY xBAIRRO                 // Bairro
//@ 12, 017 PSAY xMUN_CLI               // Municipio
//@ 12, 070 PSAY xEST_CLI              // U.F.
//@ 12, 095 PSAY xCEP_CLI Picture "@R 99999-999"           // CEP
@ 11+nDPort, 017 PSAY xMUN_CLI               // Municipio
@ 11+nDPort, 070 PSAY xEST_CLI              // U.F.
@ 11+nDPort, 095 PSAY xCEP_CLI Picture "@R 99999-999"           // CEP


//@ 22, 128 PSAY XVENC_DUP1      //23-114                 //VENCIMENTO REAL DUPLICATA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados dos Produtos Vendidos         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//nLin := 15
nLin :=14+nDPort
ImpDet()                 // Detalhe da NF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo dos Impostos                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLin := nLin + 1
                           
xVLRISS := xTOT_FAT * 5 / 100

//@ 31, 033  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"  // Valor Total NF
//@ 31, 054  PSAY xVLRISS     Picture "@E@Z 999,999,999.99"  // Valor do Iss
//@ 31, 082  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"  // Valor Total Servico
@ 30+nDPort, 033  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"  // Valor Total NF
@ 30+nDPort, 054  PSAY xVLRISS     Picture "@E@Z 999,999,999.99"  // Valor do Iss
@ 30+nDPort, 082  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"  // Valor Total Servico
///If xEst_Cli == "EX"
//	@ 31, 108  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"  // Valor Total NF
	@ 30+nDPort, 108  PSAY xTOT_FAT    Picture "@E@Z 999,999,999.99"  // Valor Total NF
///Else
///	@ 31, 108 PSAY (xTOT_FAT - xIRRF - xValImp)  Picture "@E@Z 999,999,999.99" // Valor Total NF menos IRF
///Endif
//@ 32, 010 PSAY "5,00"                          //Aliquota do ISS
//@ 34, 037 PSAY xNUM_NF                      // Numero da Nota Fiscal
//@ 34, 050 PSAY xTOT_FAT     Picture "@E@Z 999,999,999.99"  // Valor Total NF
@ 31+nDPort, 010 PSAY "5,00"                          //Aliquota do ISS
@ 33+nDPort, 037 PSAY xNUM_NF                      // Numero da Nota Fiscal
@ 33+nDPort, 050 PSAY xTOT_FAT     Picture "@E@Z 999,999,999.99"  // Valor Total NF

If mv_par04 == 2
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao da Fatura/Duplicata       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	nLin:=34
	nLin:=33+nDPort
	BB:=1
	nCol := 068            //  duplicatas
	DUPLIC()
Endif

@ 39,000 PSAY " "            //48
setprc(0,0)

Return .T.
