#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "tbiconn.CH"   

#DEFINE ENTER chr(13)+chr(10)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INC_MT120   ºAutor  ³André Sarraipa     º Data ³  15/11/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada importção de planilha para rotina MATA120   ±±
±±º          ³a planilha deve ser salva em csv                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±

*/
  

User Function INC_MT120() 

Local nX     := 0
Local nY     := 0
//Local cDoc   := ""
Local lOk    := .T.     
Local cArq     := ""
//Local cDir     := ""
Local cLinha   := ""
Local lPrim    := .T.
Local aCampos  := {}
Local aDados   := {}            
LOCAL nCont    := 0  
Local nQtd		:= 0
Local nVlunit		:= 0 
 

PRIVATE lMsErroAuto := .F.  


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


MsAguarde({||IMPSC7(aDados,nCont)},"Aguarde","Lendo dados da Planilha",.F.) 

Return(.T.)
           

Static Function IMPSC7(aDados,nCont) 

Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX := 0
Local nY := 0
Local lOk := .T.  
Local cNrPCMS     := "" 
Local nQtd		:= 0
Local nVlunit	:= 0     
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
Local dDataBase             
LOcal cFilAnt

PRIVATE lMsErroAuto := .F.  
	
If !EMPTY(aDados)

  cNrPCMS:= GetSXeNum("SC7","C7_NUM")

  aCabec := {}
  aItens := {}  
    
  aadd(aCabec,{"C7_NUM" ,cNrPCMS})
  aadd(aCabec,{"C7_EMISSAO" ,dDataBase})
  aadd(aCabec,{"C7_FORNECE" ,"000001"})
  aadd(aCabec,{"C7_LOJA" ,"01"})
  aadd(aCabec,{"C7_COND" ,"003"})
  aadd(aCabec,{"C7_CONTATO" ,""})
  aadd(aCabec,{"C7_FILENT" ,cFilAnt})     
  aadd(aCabec,{"C7_NATUREZ" ,aDados[1,5]}) 
   
  For nX:=1 To len(aDados) 

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
	  cMsgem += "Empresa não cadastrado: "+cEmpresa+ENTER   

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
    aadd(aLinha,{"C7_PRODUTO" ,cProd          ,Nil})
    aadd(aLinha,{"C7_QUANT"   ,nQtd           ,Nil})
    aadd(aLinha,{"C7_PRECO"   ,nVlunit        ,Nil})
    aadd(aLinha,{"C7_TOTAL"   ,nQtd * nVlunit ,Nil})
    aadd(aLinha,{"C7_TES"     ,cTes           ,Nil})    
	aadd(aLinha,{"C7_EC05DB" ,cEmpresa        ,Nil})
	aadd(aLinha,{"C7_EC06DB" ,cResultado      ,Nil})
    aadd(aLinha,{"C7_EC07DB" ,cNucleo         ,Nil})   // NÃO TEM 
	aadd(aLinha,{"C7_EC08DB" ,cCobranca       ,Nil})
	aadd(aLinha,{"C7_CC"     ,cCusto          ,Nil})
	aadd(aLinha,{"C7_CLVL"   ,cProjeto        ,Nil})
    aadd(aLinha,{"C7_CLINFD" ,cCLINFD         ,Nil})  //NÃO TEM 
    aadd(aLinha,{"C7_LOJANFD",cLOJANFD        ,Nil})  //NÃO TEM 
	aadd(aLinha,{"C7_CONTA"  ,cContabil       ,Nil})	
    aadd(aItens,aLinha)
  Next nX 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Inclusao |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

//Begin Transaction  

 IF lOk    
     MsgAlert("Foi usado a Condição de pagamento 003 (30 DIAS QUARTAS) e o fornecedor 000001-01, antes de confirmar a inclusão favor alterar!!!")

     MATA120(1,aCabec,aItens,3,.T.) 
 
     If !lMsErroAuto
       
    	dbSelectArea("SC7")
        dbSetOrder(1)
      
        If SC7->(MsSeek(xFilial("SC7")+cNrPCMS))    //Avalio se o numero reservado pelo GetSXeNum foi gravado caso contrario libero o numero
            msgalert("Incluido com sucesso! "+cNrPCMS)       
           ConfirmSX8()  
        else
         ROLLBACKSX8()
        endif
     Else  
       MostraErro()   
       ROLLBACKSX8()
     EndIf
 ELSE  
		MsgAlert(cMsgem,"Erro na importação")  
		ROLLBACKSX8()	
 ENDIF  

EndIf

 


Return(.T.)