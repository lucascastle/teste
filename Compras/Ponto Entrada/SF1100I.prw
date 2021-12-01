#INCLUDE "rwmake.ch"                
#INCLUDE "TOPCONN.CH"       
#include "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SF1100I   ºAutor  ³Richard Branco      º Data ³  22/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada utilizado para indicar se o Documento de   º±±
±±º          ³entrada se refere a uma Nota de Débito.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 8 - Inpress                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes   ³                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAnalista     ³  Data  ³ Motivo                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºEduardo Cseh ³07/02/14³ #ECV20140207 - Ajuste para gravar as entidades º±±
±±ºAgility      ³        ³ contabeis nos titulos gerados.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º             ³        ³                                                º±±
±±º             ³        ³                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


user function SF1100I    

Local _aAreSD1	:= SD1->(GetArea())	//#ECV20140207.new
Local _aAreSE2	:= SE2->(GetArea())	//#ECV20140207.new 
Local _aAreSF1	:= SF1->(GetArea())

Local oButton1
Local oButton2
Local oSay1  
local _nOpc := 1
local oDlg
Local _cDataServ := FwTimeUF('SP')[1]


//#ECV20140207.begin new
If !SF1->F1_TIPO $ '"D/B'	//Se a nota nao for de devolucao ou beneficiamento
	SD1->(dbSetorder(1))	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	If SD1->(dbSeek(xfilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
		
		SE2->(dbsetorder(6))	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		If SE2->(dbSeek(xfilial("SE2")+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)))
	
			While !SE2->(Eof()) .And. Alltrim(SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)) == Alltrim(SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM))
				
				RecLock("SE2",.F.)	
					SE2->E2_EC05DB	:= SD1->D1_EC05DB	//Empresa     
					SE2->E2_EC06DB	:= SD1->D1_EC06DB	//Centro de resultado
					SE2->E2_EC07DB	:= SD1->D1_EC07DB	//Nucleo
					SE2->E2_EC08DB	:= SD1->D1_EC08DB	//Cobranca
					SE2->E2_CC		:= SD1->D1_CC		//Centro de Custo
					SE2->E2_CLVL	:= SD1->D1_CLVL		//Projeto
				MsUnLock()	
		     	
		     	SE2->(dbSkip())
		     	
		     End
		EndIf	
	EndIf
EndIf

//Ajuste para gravar o usuario e data do servidor - Edmar Paranhos 03/09/2021

	If cEmpAnt $ "01/04/11/12/13/14/16/17/18/19/35" //Apenas para empresas que possuem os campos criados 
	
        //Grava o conteúdo na SF1
        RecLock("SF1", .F.)
        
            SF1->F1_XDATASE := STOD(_cDataServ)                                                                                                               
            SF1->F1_XUSERID := cUserName
            SF1->(MsUnlock())

	Endif

SF1->(RestArea(_aAreSF1))
SD1->(RestArea(_aAreSD1))
SE2->(RestArea(_aAreSE2))

//#ECV20140207.end new

//_nOpc:=Aviso('Nota de Debito','Esta nota fiscal pertence a Nota de Debito ?',{'Não','Sim'})   //03.11.2015    

//********* 03.11.2015 - Incluido para substituir o Aviso() pois não funciona no MSExecAuto() --- inicio
  DEFINE MSDIALOG oDlg TITLE "Nota de Debito" FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL

     
    @ 058, 045 BUTTON oButton1 PROMPT "Sim" SIZE 037, 012 PIXEL OF oDlg ACTION (_nopc := 2, oDlg:End())
    @ 057, 097 BUTTON oButton2 PROMPT "Não" SIZE 037, 012 OF oDlg PIXEL  Action oDlg:End()     
   
    @ 039, 034 SAY oSay1 PROMPT "Esta nota fiscal pertence a Nota de Debito ?" SIZE 125, 010 OF oDlg COLORS 0, 16777215 PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED      
//********* 03.11.2015 - Incluido para substituir o Aviso() pois não funciona no MSExecAuto() ---Fim

if _nopc == 2
	_codcli  := space(06)
	_lojcli  := space(02)
	_produto := space(15)
	_produto := "NDB"+SD1->D1_COD
	//_ccusto  := Space(09)
	display := "Nota de Debito"
	DEFINE MSDIALOG oDlg1 FROM  100,1 TO 200,300  TITLE DISPLAY PIXEL
	//@ 10,05 say "Cliente.:"
	//@ 10,50 get _codcli VALID existcpo("SA1").and. NaoVazio() F3 "SA1" SIZE 35,09
	//@ 25,05 say "Loja..:"
	//@ 25,50 get _lojcli //SIZE 35,09             
	@ 10,05 say "Produto.:" 
	@ 10,50 get _produto pICTURE "@!" VALID existcpo("SB1").and. NaoVazio() F3 "NDB" SIZE 50,080                                
	//@ 60,05 say "C.Custo.:" 
	//@ 60,50 get _ccusto pICTURE "@!" VALID existcpo("CTT").and. NaoVazio() F3 "CTT" SIZE 50,080                                

	DEFINE SBUTTON FROM 25, 010 TYPE  1 ENABLE OF oDlg1 Action GRAVANFD()
	DEFINE SBUTTON FROM 25, 050 TYPE  2 ENABLE OF oDlg1 Action sairnfd()

	ACTIVATE MSDIALOG oDlg1 Centered 				
ENDIF	
Return(.t.)

STATIC FUNCTION GRAVANFD	
    dbselectarea("se2")
	dbsetorder(6)
	dbseek(xfilial()+sf1->f1_fornece+sf1->f1_loja+sf1->f1_serie+sf1->f1_doc)
	do while !eof() .and. (xfilial()+sf1->f1_fornece+sf1->f1_loja+sf1->f1_serie+sf1->f1_doc) == (se2->e2_filial+se2->e2_fornece+se2->e2_loja+se2->e2_prefixo+se2->e2_num)
		reclock("se2",.f.)
		se2->e2_nfdeb  := "S"
		se2->e2_pronfd := _produto
		se2->(msunlock())
		dbskip()
	enddo       
	
	//Atualiza Itens do Documento de Entrada
	dbselectarea("SD1")
	dbsetorder(1)
	dbGotop()
	dbseek(xfilial()+sf1->f1_doc+sf1->f1_serie+sf1->f1_fornece+sf1->f1_loja)
	do while !eof() .and. (xfilial()+sf1->f1_doc+sf1->f1_serie+sf1->f1_fornece+sf1->f1_loja) == (sd1->d1_filial+sd1->d1_doc+sd1->d1_serie+sd1->d1_fornece+sd1->d1_loja)
	
		reclock("sd1",.f.)   
		
		sd1->d1_nfdeb   := "S"
		sd1->(msunlock())
	
		dbskip()
	enddo       
	
	close(oDlg1)
RETURN(.T.)

static function sairnfd  

Local oButton1
Local oButton2
Local oSay1  
local _nopc1 := 2
Static oDlg
//_nOpc1:=Aviso('Nota de Debito','Tem certeza que deseja cancelar a amarraçao da Nota de Debito?',{'Sim','Não'})   

//********* 03.11.2015 - Incluido para substituir o Aviso() pois não funciona no MSExecAuto() --- inicio
   DEFINE MSDIALOG oDlg TITLE "Nota de Debito" FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL

     
    @ 058, 045 BUTTON oButton1 PROMPT "Sim" SIZE 037, 012 PIXEL OF oDlg ACTION (_nopc1 := 1, oDlg:End())
    @ 057, 097 BUTTON oButton2 PROMPT "Não" SIZE 037, 012 OF oDlg PIXEL  Action oDlg:End()     
   
    @ 039, 020 SAY oSay1 PROMPT "Tem certeza que deseja cancelar a amarraçao da Nota de Debito?'" SIZE 169, 017 OF oDlg COLORS 0, 16777215 PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED     
//********* 03.11.2015 - Incluido para substituir o Aviso() pois não funciona no MSExecAuto() ---Fim
if _nopc1 == 1
  close(oDlg1)
endif
return(.t.)
