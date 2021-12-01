#include 'protheus.ch'
#include 'parmtype.ch'
#include "rwmake.ch"
#include "TbiConn.ch"    


#DEFINE ENTER chr(13)+chr(10)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INC_Mt103   ºAutor  ³André Sarraipa     º Data ³  04/11/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada importção de planilha para rotina MATA103   ±±
±±º          ³a planilha deve ser salva em csv                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±

*/

User Function INC_Mt103()

Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local nY     := 0
Local cDoc   := ""    
Local cArq     := ""
Local cDir     := ""
Local cLinha   := ""
Local lPrim    := .T.
Local aCampos  := {}
Local aDados   := {}            
LOCAL nCont    := 0  
Local nQtd		:= 0
Local nVlunit		:= 0
Local cFormul
Local dDEmissao  
                                           
If( Empty(cA100For) .or. Empty(cNFiscal) .or. Empty(cEspecie) )
		MsgAlert("Preecha o cabeçalho do documento; Fornecedor, Numero e Espec Docum   ")
		Return(.T.)
EndIf   
      
//Valida se o doc ja existe
DbSelectArea("SF1")	
DbSetOrder(1)
If SF1->(MsSeek(xFilial("SF1")+cNFiscal+cSerie+cA100For+cLoja+cTipo))
    MsgAlert("Número de nota fiscal já cadastrado!!!")
    Return(.T.)
Endif  
	
cArq := cGetFile('Arquivo *|*.csv|Arquivo csv|*.csv','Todos os Drives',0,'C:\Dir\',.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.)

   
//Validar se o arquivo foi selecionado
if empty(cArq)   
   MsgAlert("Arquivo não selecionado")  
   Return(.T.)
endif



//***********INcluido para ler csv       

FT_FUSE(cArq)
ProcRegua(FT_FLASTREC())
FT_FGOTOP()
While !FT_FEOF()
 
	IncProc("Lendo arquivo texto...")
 
	cLinha := FT_FREADLN()
 
	If lPrim
		aCampos := Separa(cLinha,";",.T.)
		lPrim := .F.
	Else
		AADD(aDados,Separa(cLinha,";",.T.))    
		
			nCont++                                       
		
	EndIf                       
 
	FT_FSKIP()
	
EndDo


If EMPTY(aDados) .or.  EMPTY(nCont)    
   MsgAlert("Erro na leitura do arquivo!!!")  
   Return(.T.)
ENDIF

MsAguarde({||GeraExcel(aDados,nCont)},"Aguarde","Importando dados da Planilha",.F.)     



Return(.T.)
           

Static Function GeraExcel(aDados,nCont) 

Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local nY     := 0
Local cDoc   := ""
Local lOk    := .T.     
Local cArq       := ""
Local cDir       := ""
Local cLinha     := ""
Local lPrim      := .T.
Local aCampos    := {}
Local nQtd	     := 0
Local nVlunit	 := 0  
Local cCLINFD    :=""         
Local cLOJANFD   :=""   
Local cMsgem     :=""    
Local cTes       :="" 
Local cProd      :=""
Local cNat       :=""    
Local cEmpresa   :=""   
Local cResultado :=""  
Local cNucleo    :="" 
Local cCobranca  := ""       
Local cCusto     :=""      
Local cProjeto   :=""     
Local cContabil  :=""

//Private lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

	
If !EMPTY(aDados)	

	aCabec := {}		
	aItens := {}
	
	aadd(aCabec,{"F1_TIPO"       ,cTipo})		
	aadd(aCabec,{"F1_FORMUL"     ,cFormul})		
	aadd(aCabec,{"F1_DOC"        ,cNFiscal})		
	aadd(aCabec,{"F1_SERIE"      ,cSerie})		
	aadd(aCabec,{"F1_EMISSAO"    ,dDEmissao})		
	aadd(aCabec,{"F1_FORNECE"    ,cA100For})		
	aadd(aCabec,{"F1_LOJA"       ,cLoja})		
	aadd(aCabec,{"F1_ESPECIE"    ,cEspecie})		
	aadd(aCabec,{"F1_COND"       ,"003"})		
	aadd(aCabec,{"F1_DESPESA"    ,0})				
   	aadd(aCabec,{"E2_NATUREZ"    ,aDados[1,5]})		
	
	For nX:=1 To nCont		
	
	    //Convertendo , para .
	    nQtd	:= Val(StrTran(aDados[nx,2],',','.'))
	    nVlunit	:= Val(StrTran(aDados[nx,3],',','.'))     
	    
	    //Tratamento de zero para o codigo do cliente
	       if !empty(aDados[nx,12])          
	       
	          cCLINFD :=StrZero(val(aDados[nx,12]),6)  
	          cLOJANFD :=StrZero(val(aDados[nx,13]),2)   
	            
	             //Validação de cliente
	             DbSelectArea("SA1")
	             DbSetOrder(1)
	              
	             If !SA1->(MsSeek(xFilial("SA1")+cCLINFD+cLOJANFD))
	                 lOk := .F.	     
		             cMsgem += "Cliente não cadastrado: "+cCLINFD+"-"+cLOJANFD+ENTER   
	             EndIf     
	       else  
	          cCLINFD  :=""
	          cLOJANFD :=""
	       endif 
	//Validação da TES       
	    DbSelectArea("SF4")
		DbSetOrder(1)       
		cTes := StrZero(val(aDados[nx,4]),3) 
		
		if cTes  > "500"    
			lOk := .F.	     
		    cMsgem += "TES de entrada deve ser menor ou igual a 500 verifique a TES: "+cTes+ENTER  	
		ELSE
		
		 If !SF4->(MsSeek(xFilial("SF4")+cTes))
	    	lOk := .F.	     
		    cMsgem += "TES não cadastrada: "+cTes+ENTER   
	   	 ELSE     
		   IF SF4->F4_MSBLQL = "1"  
		      lOk := .F.
		      cMsgem += "A TES está bloqueada: "+cTes+ENTER   
		   ENDIF	
	     EndIf
		ENDIF         
		
	 //Validação do produto cProd 
	   DbSelectArea("SB1")
	   DbSetOrder(1)
	   cProd := aDados[nx,1]  
	   
	   If !SB1->(MsSeek(xFilial("SB1")+cProd))	
	
	      lOk := .F.	     
		  cMsgem += "Produto não cadastrado: "+cProd+ENTER   
	
	   EndIf         
	   
	 //VAlidação da natureza
	   DbSelectArea("SED")
	   DbSetOrder(1)
	   cNat := aDados[nx,5] 
	   
	   If !SED->(MsSeek(xFilial("SED")+cNat))	
	
	      lOk := .F.	     
		  cMsgem += "Natureza não cadastrado: "+cNat+ENTER   
	
	   EndIf       
	//Empresa 	
	   DbSelectArea("CV0")
	   DbSetOrder(2)
	   cEmpresa := aDados[nx,6] 
	   
	   If !CV0->(MsSeek(xFilial("CV0")+cEmpresa))	
	
	      lOk := .F.	     
		  cMsgem += "Empresa não cadastrada: "+cEmpresa+ENTER   
	
	   EndIf  
	//C. Resultado
	   DbSelectArea("CV0")
	   DbSetOrder(2)
	   cResultado := aDados[nx,7] 
	   
	   If !CV0->(MsSeek(xFilial("CV0")+cResultado))	
	
	      lOk := .F.	     
		  cMsgem += "C. Resultado não cadastrado: "+cResultado+ENTER   
	
	   EndIf  
	 	
	//Nucleo 
	   DbSelectArea("CV0")
	   DbSetOrder(2)
	   cNucleo := StrZero(val(aDados[nx,8]),6) 
	   
	   If !CV0->(MsSeek(xFilial("CV0")+cNucleo))	
	
	      lOk := .F.	     
		  cMsgem += "Nucleo não cadastrado: "+cNucleo+ENTER   
	
	   EndIf  	
	//Cobranca	
	DbSelectArea("CV0")
	   DbSetOrder(2)
	   cCobranca := StrZero(val(aDados[nx,9]),3)
	   
	   If !CV0->(MsSeek(xFilial("CV0")+cCobranca))	
	
	      lOk := .F.	     
		  cMsgem += "Cobranca não cadastrada: "+cCobranca+ENTER   
	
	   EndIf
	//C. custo 
	DbSelectArea("CTT")
	   DbSetOrder(1)
	   cCusto := aDados[nx,10]
	   
	   If !CTT->(MsSeek(xFilial("CTT")+cCusto))	
	
	      lOk := .F.	     
		  cMsgem += "Centro de Custo não cadastrado: "+cCusto+ENTER   
	
	   EndIf	 
	
	//Projeto	  
	DbSelectArea("CTH")
	   DbSetOrder(1)
	   cProjeto := aDados[nx,11]
	   
	   If !CTH->(MsSeek(xFilial("CTH")+cProjeto))	
	
	      lOk := .F.	     
		  cMsgem += "Projeto não cadastrado: "+cProjeto+ENTER   
	
	   EndIf
	
	//C Contabil 
	DbSelectArea("CT1")
	   DbSetOrder(1)
	   cContabil := aDados[nx,14]
	   
	   If !CT1->(MsSeek(xFilial("CT1")+cContabil))	
	
	      lOk := .F.	     
		  cMsgem += "C Contabil não cadastrada: "+cContabil+ENTER   
	
	   EndIf
	
	 //Fim da validação
				
		aLinha := {}			
		aadd(aLinha,{"D1_COD"    ,cProd,Nil})			
		aadd(aLinha,{"D1_QUANT"  ,nQtd,Nil})			
		aadd(aLinha,{"D1_VUNIT"  ,nVlunit,Nil})			
		aadd(aLinha,{"D1_TOTAL"  ,nQtd * nVlunit,Nil})			
		aadd(aLinha,{"D1_TES"    ,cTes,Nil})
	    aadd(aLinha,{"D1_NATUREZ",cNat,Nil})
		aadd(aLinha,{"D1_EC05DB" ,cEmpresa,Nil})
		aadd(aLinha,{"D1_EC06DB" ,cResultado,Nil})
		aadd(aLinha,{"D1_EC07DB" ,cNucleo,Nil})  
		aadd(aLinha,{"D1_EC08DB" ,cCobranca,Nil})
		aadd(aLinha,{"D1_CC"     ,cCusto,Nil})
		aadd(aLinha,{"D1_CLVL"   ,cProjeto,Nil})
		aadd(aLinha,{"D1_CLINFD" ,cCLINFD,Nil})
		aadd(aLinha,{"D1_LOJANFD",cLOJANFD,Nil})
		aadd(aLinha,{"D1_CONTA"  ,cContabil,Nil})			
		aadd(aItens,aLinha)			

	Next nX		   
	               
	
	IF lOk  // Verifica se alguma validação de erro 
	
    	MsgAlert("Foi usado a Condição de pagamento 003 (30 DIAS QUARTAS), antes de confirmar a inclusão favor alterar!!!")	            
	            
     	MSExecAuto({|x,y,z,w| mata103(x,y,z,w)},aCabec,aItens,3,.T.)    
     	
     		//Verifique se o doc passado pelo para importação foi incluiso caso não mostra o erro
     	DbSelectArea("SF1")	
		DbSetOrder(1)
		If !SF1->(MsSeek(xFilial("SF1")+cNFiscal+cSerie+cA100For+cLoja+cTipo))
    			
    			If lMsErroAuto			     
	    		   mostraerro() 		
                ENDIF	
		Endif 
	
	ELSE  
		MsgAlert(cMsgem,"Erro na importação")
	
	ENDIF  
	
	
	//If lMsErroAuto			
                         
	    //mostraerro() 		

   // ENDIF	
	 
	
EndIf

Return(.T.)

