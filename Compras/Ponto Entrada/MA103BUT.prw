#include 'protheus.ch'
#include 'parmtype.ch'    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA103BUT   �Autor  �Andr� Sarraipa      � Data �  04/11/2015���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada incluir boto�o no a�oes relacionadas MATA103��
���          �                                                            ���
�������������������������������������������������������������������������͹��

*/

User function MA103BUT()

Local aRet := {}

aAdd(aRet, {"NOTE",{||U_INC_Mt103()},OemToAnsi("Selecione o doc para importa��o"),"Importa Itens"} )

Return(aRet)
	
