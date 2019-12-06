#Include "Protheus.ch"

/*/{Protheus.doc} MTA650A

A650Altera() - Programa de altera��o de O.P.s
� executado ap�s a grava��o de todos os registros de altera��o realizado
na fun��o A650Altera(rotina de altera��o do cadastramento de Ordens de Produ��o).

@author 	Marcos Nat� Santos
@since 		19/05/2019
@version 	12.1.17
/*/
User Function MTA650A
    Local cProduto := SC2->C2_PRODUTO
    Local cOP      := SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN
    Local nQtd     := SC2->C2_QUANT
    Local dDtIni   := SC2->C2_DATPRI
    Local dDtFim   := SC2->C2_DATPRF
    Local dDtEmis  := SC2->C2_EMISSAO

    U_LTPostOrder(cProduto, cOP, nQtd, dDtIni, dDtFim, dDtEmis)

Return