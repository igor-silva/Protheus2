#Include "Protheus.ch"

/*/{Protheus.doc} MTA650I

Gera��o de Ordens de Produ��o
Este ponto de entrada � chamado nas fun��es: A650Inclui (Inclus�o de OP's)
A650GeraC2 (Gera Op para Produto/Quantidade Informados nos par�metros).

@author 	Marcos Nat� Santos
@since 		19/05/2019
@version 	12.1.17
/*/
User Function MTA650I
    Local cProduto := SC2->C2_PRODUTO
    Local cOP      := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
    Local nQtd     := SC2->C2_QUANT
    Local dDtIni   := SC2->C2_DATPRI
    Local dDtFim   := SC2->C2_DATPRF
    Local dDtEmis  := SC2->C2_EMISSAO

    U_LTPostOrder(cProduto, cOP, nQtd, dDtIni, dDtFim, dDtEmis)

Return