#INCLUDE "rwmake.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103IPC   ºAutor  ³André Sarraipa     º Data ³   15/11/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada importção campos customizados do pedido de  ±±
±±º          ³compra para o documento de entrada                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±

*/



User Function MT103IPC   


Local _nNat    := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_NATUREZ"})
Local _nEc07   := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_EC07DB"})   
Local _nClinfd := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_CLINFD"}) 
Local _nLojnfd := AsCan(aHeader,{|x|Alltrim(x[2])=="D1_LOJANFD"}) 
Private _nItem   := PARAMIXB[1]

If  _nItem > 0      
 aCols[_nItem,_nNat]    := SC7->C7_NATUREZ    
 aCols[_nItem,_nEc07]   := SC7->C7_EC07DB    
 aCols[_nItem,_nClinfd] := SC7->C7_CLINFD  
 aCols[_nItem,_nLojnfd] := SC7->C7_LOJANFD           
Endif


Return Nil