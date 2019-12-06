#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} MTA410

Valida��o de toda a tela no Pedido de Venda

@type User Function
@author Marcos Nat� Santos
@since 12/10/2019
@version 1.0
@return lRet, logic
/*/
User Function MTA410()
    Local lRet := .T.

    //-- Fun��o para processar Campanha Comprou Ganhou --//
    lRet := U_MNTFN001()

Return lRet