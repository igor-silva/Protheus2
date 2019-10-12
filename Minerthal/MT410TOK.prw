#INCLUDE "PROTHEUS.CH"
/*/{Protheus.doc} MT410TOK

Este ponto de entrada � executado ao clicar no bot�o OK e pode ser usado para
validar a confirma��o das opera��es: incluir,  alterar, copiar e excluir.
Se o ponto de entrada retorna o conte�do .T., o sistema continua a opera��o,
caso contr�rio, volta para a tela do pedido.

@type User Function
@author Marcos Natã Santos
@since 10/10/2019
@version 1.0
@return lRet, logic
/*/
User Function MT410TOK()
    Local lRet := .T.
    Local nOpc := PARAMIXB[1]

    lRet := U_MNTFN001(nOpc)

Return lRet