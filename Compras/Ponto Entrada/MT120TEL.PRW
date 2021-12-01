
#include "rwmake.ch"
#include "protheus.ch"

User Function MT120TEL()

Local oNewDialog := PARAMIXB[1]
Local aPosGet    := PARAMIXB[2]
Local aObj       := PARAMIXB[3]
Local nOpcx      := PARAMIXB[4]
Public _cnATUREZ :=Space(TamSx3("C7_NATUREZ")[1])


If nOpcx <> 3
_cnATUREZ := SC7->C7_NATUREZ
EndIf

@ 54,492 SAY "Natureza" OF oNewDialog PIXEL SIZE 060,006
@ 53,564 MSGET _cnATUREZ PICTURE PesqPict("SC7","C7_NATUREZ") F3 CpoRetF3("C7_NATUREZ",'SED') OF oNewDialog PIXEL SIZE 060,006

Return(.T.)
