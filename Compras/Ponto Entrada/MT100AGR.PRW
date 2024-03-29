#Include "rwmake.ch"
#Include "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100AGR  � Autor � Alan S. R. Oliveira� Data �  24/03/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada na Geracao da Nota Fiscal de Entrada para ���
���          � gravacao de campo.                                         ���
�������������������������������������������������������������������������͹��
���Uso       � Inpress                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT100AGR

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local aAreas		:= {SD1->(GetArea()),SE2->(GetArea()),SE1->(GetArea()),GetArea()}

//Private cString      := "SD1"
Private cOldAlias    := Alias()

Private nSD1Order    := SD1->(IndexOrd())
Private nSD1Recno    := SD1->(Recno())
Private nSE2Order    := SE2->(IndexOrd())
Private nSE2Recno    := SE2->(Recno())
Private nSE1Order    := SE1->(IndexOrd())
Private nSE1Recno    := SE1->(Recno())
private Inclui

//Private _cItemctba   := ""
//Private _cClvalor    := ""

//Chama Tela do Item Cont�bil
//ITCTBA()
//Grava Itens da Nota
/*
DbSelectArea("SD1")
DbSetOrder(1)
DbSeek(xFilial() + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) 

While !Eof() .AND. SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA==SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

	RecLock("SD1", .F. )

		SD1->D1_ITEMCTA := _cItemctba
		
	MSUnLock()

	DbSelectArea("SD1")
	DbSkip()	
Enddo       
*/

If SF1->F1_TIPO <> "D"
	
	DbSelectArea("SE2")
	DbSetOrder(1)
	If DbSeek(xFilial() + SF1->F1_PREFIXO + SF1->F1_DOC )
		
		While !EOF() .and. SE2->E2_PREFIXO == SF1->F1_PREFIXO .and. ;
			SE2->E2_NUM     == SF1->F1_DOC
			
			//RecLock("SE2", .F. )
			
				//SE2->E2_ITEMC   := _cItemctba  
				
			   //SE2->E2_CLVLCR	 :=	_cClvalor	
		
			MSUnLock()
			
			DbSkip()
			
		EndDO
		
	EndIf
	
Else
	

	DbSelectArea("SE1")
	DbSetOrder(1)
	If DbSeek(xFilial() + SF1->F1_PREFIXO + SF1->F1_DOC )
		
		While !EOF() .and. SE1->E1_PREFIXO == SF1->F1_PREFIXO .and. ;
			SE1->E1_NUM     == SF1->F1_DOC
			
			//RecLock("SE1", .F. )
			
			//SE1->E1_ITEMC   := _cItemctba    
			
			//SE1->E1_CLVLCR	 :=	_cClvalor	
			
			//MSUnLock()
			
			DbSkip()
			
		End
		
	EndIf
	
EndIf

//Grava Cabe�alho da Nota
//RecLock("SF1", .F. )
		
//	SF1->F1_XITEMCC := _cItemctba
			                                
//	SF1->F1_XCLVL 	 :=	_cClvalor				
	
//MSUnLock() 


//TRATAMENTO JA EXISTENTE NO CLIENTE
If !Inclui
	Return
EndIf

dbSelectArea("SE2")
dbSetOrder(1)
dbSeek(xFilial("SE2") + SF1->F1_SERIE + SF1->F1_DOC,.T.)

While SE2->(!EOF()) .And. SE2->E2_PREFIXO + SE2->E2_NUM == SF1->F1_SERIE + SF1->F1_DOC

	RecLock("SE2",.F.)
		SE2->E2_FLUXO := "S"
	MsUnlock()
	
	SE2->(dbSkip())

EndDo

/*
DbSelectArea("SD1")
DbSetOrder(nSD1Order)
DbGoTo(nSD1Recno)

DbSelectArea("SE2")
DbSetOrder(nSE2Order)
DbGoTo(nSE2Recno)

DbSelectArea("SE1")
DbSetOrder(nSE1Order)
DbGoTo(nSE1Recno)

DbSelectArea(cOldAlias)
*/
AEval(aAreas, {|x| RestArea(x) } )

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �TesGaia   � Autor � Alan S. R. Oliveira   � Data �31/03/2009���
�������������������������������������������������������������������������Ĵ��
���Locacao   �                  �Contato �                                ���
�������������������������������������������������������������������������Ĵ��
���Descricao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Bops � Manutencao Efetuada                    ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �      �                                        ���
���              �  /  /  �      �                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
/*
Static Function ITCTBA()

Local   oGet1
Private cGet1 := Space(9)
Private oDlg	

DEFINE MSDIALOG oDlg TITLE "DIGITA��O ITEM CONT�BIL" FROM C(178),C(181) TO C(289),C(470) PIXEL

// Cria Componentes Padroes do Sistema
@ C(011),C(041) MsGet oGet1 Var cGet1 VALID VALMT(cGet1) F3 "CTD" Size C(069),C(009) COLOR CLR_RED   Picture "@!" PIXEL OF oDlg
@ C(012),C(005) Say "Item Cont�bil: " Size C(036),C(008) COLOR CLR_BLUE  PIXEL OF oDlg

DEFINE SBUTTON FROM C(038),C(109) TYPE 19 ENABLE OF oDlg ACTION(oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

Return(.T.)
*/ 


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()   � Autores � Norbert/Ernani/Mansano � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolucao horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
/*
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//���������������������������Ŀ
//�Tratamento para tema "Flat"�
//�����������������������������
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)
 */
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  VALMT      � Autor � Alan S. R. Oliveira� Data �  24/03/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Validacao do Campo Digitado                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Inpress                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Static Function VALMT(cGet1)
Local _lRet := .T.


If !Empty(cGet1)
	_cItemctba := cGet1
	oDlg:End()
Else
	//Msginfo("Voce nao esta informando o Item Cont�bil !!!")
	_nOpc1:=Aviso('Item Contabil','Voce nao informou o Item Contabil, deseja informar?',{'Sim','N�o'})
	If _nOpc1 == 1
		_lret := .F.
	Else
		_lret := .T.	
	Endif
	Return _lRet
Endif

Return _lRet
*/