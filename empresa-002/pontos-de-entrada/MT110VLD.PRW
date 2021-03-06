#Include "Protheus.ch"

/*/{Protheus.doc} MT110VLD
Valida o registro na solicita��o de compras
@author Marcos Nat� Santos
@since 03/10/2017
@version 1.0
@return l�gico, ExpL1

@type function
/*/
User Function MT110VLD()
	Local ExpN1 := Paramixb[1] // 3-Inclus�o | 4-Altera��o | 8-C�pia | 6-Exclus�o
	Local ExpL1 := .T.
	Local nUsuario := SC1->C1_USER
	Local aRetUser := PswRet()

	/*
	* Somente o solicitante pode alterar/excluir sua solicita��o,
	* exce��o apenas para os usu�rios do departamento GTI
	* que podem alterar qualquer solicita��o.
	*/

	If ExpN1 = 4 .Or. ExpN1 = 6
		If nUsuario = aRetUser[1][1] .Or. "GTI" $ aRetUser[1][12]
			ExpL1 := .T.
		Else
			ExpL1 := .F.
			MsgAlert("Somente o Solicitante pode redefinir ou excluir esta solicita��o.")
		EndIf
	EndIf

Return ExpL1