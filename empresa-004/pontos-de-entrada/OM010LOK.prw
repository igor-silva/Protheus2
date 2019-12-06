/*/{Protheus.doc} OM010LOK
Tabela de Pre�os
Ponto de entrada executado somente se a valida��o dos itens estiver ok,
permitindo ao usu�rio interferir na valida��o.
@type  User Function
@author Marcos Nat� Santos
@since 12/07/2019
@version 1.0
@return lRet, logical, Valida��o de linha
/*/
User Function OM010LOK
    Local lRet := .T.
    Local oModel := FWModelActive()
    Local oModelDA1 := oModel:GetModel("DA1DETAIL")
    Local nX := 0
    Local cMsg := ""

    For nX := 1 To oModelDA1:length()
        oModelDA1:GoLine(nX)
        If oModelDA1:IsInserted() .Or. oModelDA1:IsUpdated()
            lRet := DuplProd(oModelDA1, AllTrim( oModelDA1:GetValue("DA1_CODPRO")))
            If !lRet
                cMsg := "Produto " + AllTrim(oModelDA1:GetValue("DA1_CODPRO")) + " j� existe na tabela."
                Help('',1,,"Produto em duplicidade",cMsg,1,0)
                Exit
            EndIf
        EndIf
    Next nX

Return lRet

/*/{Protheus.doc} DuplProd
Valida duplicidade de item na tabela de pre�o
@type  Static Function
@author Marcos Nat� Santos
@since 12/07/2019
@version 1.0
@param cProduto, char, C�digo do produto
@return lRet, logic, Valida��o
/*/
Static Function DuplProd(oModel, cProduto)
    Local lRet := .T.
    Local nX := 0
    Local nDupl := 0

    For nX := 1 To oModel:length()
        oModel:GoLine(nX)
        If AllTrim(oModel:GetValue("DA1_CODPRO")) == cProduto
            nDupl++
        EndIf
    Next nX

    If nDupl > 1
        lRet := .F.
    EndIf
Return lRet