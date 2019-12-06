#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} nomeFunction

Localizado na Solicita��o de Compras, este ponto de entrada
� respons�vel em validar o registro posicionado da Solicita��o
de Compras antes de executar as opera��es de inclus�o, altera��o,
exclus�o e c�pia. Se retornar .T., deve executar as opera��es de
inclus�o, altera��o, exclus�o e c�pia ou .F. para interromper o processo.

@type User Function
@author Marcos Nat� Santos
@since 07/11/2019
@version 1.0
@return lRet, logic
/*/
User Function MT110VLD()
	Local lRet := .T.
	Local nOper :=  PARAMIXB[1]
	Local cUsuario := SC1->C1_USER

	If nOper = 4 .Or. nOper = 6 // 4 = Altera��o | 6 = Exclus�o
		If .Not. FwIsAdmin()
			If cUsuario <> __cUserID
				lRet := .F.
				MsgAlert("Somente o solicitante pode redefinir ou excluir esta solicita��o.", "ATEN��O")
			EndIf
		EndIf
	EndIf
Return lRet