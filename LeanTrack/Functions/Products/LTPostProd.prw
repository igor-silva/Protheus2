#Include "Protheus.ch"
#Include "RestFul.ch"

/*/{Protheus.doc} LTPostProd

DESCRI��O DOS PAR�METROS
------------------------------------------------------------------
Campo	  | Regras	     |  Detalhes                             |
------------------------------------------------------------------
descricao | obrigat�rio	 |  Descri��o do produto                 |
codigo	  | obrigat�rio	 |  Identificador �nico do produto       |
unidade	  | obrigat�rio	 |  Unidade do produto ex: (Caixa 15 und)|
------------------------------------------------------------------


DESCRI��O DA RESPOSTA
---------------------------------------------
Campo	            | Detalhes              |
---------------------------------------------
total_count	        | Quantidade Processada |
rows_created_count	| Quantidade Cadastrada |
rows_updated_count	| Quantidade Atualizada |
rows_failed_count   | Quantidade que Falhou |
rows_failed	        | Lista de falhas       |
---------------------------------------------

@author 	Marcos Nat� Santos
@since 		15/05/2019
@version 	12.1.17
/*/
User Function LTPostProd(cProduto, cDescricao, cUnidade)
	Local cUrl        := SuperGetMv("LT_URL", .F., "https://demo.leantrack.com.br")
	Local oLeanTrack  := FWRest():New(cUrl)
	Local cAuthToken  := U_LTGetToken()
	Local aHeader     := {}
	Local cJSON       := ""

	Default cProduto   := ""
	Default cDescricao := ""
	Default cUnidade   := ""
	
	aAdd(aHeader, "Content-Type: application/json")
	aAdd(aHeader, "Authorization: Bearer " + cAuthToken)

	cJSON := '[{"descricao": "'+ cDescricao +'","codigo": "'+ cProduto +'","unidade": "'+ cUnidade +'"}]'
	
	oLeanTrack:setPath("/api/integration/products")
	oLeanTrack:SetPostParams(cJSON)

	If oLeanTrack:Post(aHeader)
		ConOut("LEANTRACK /api/integration/products -> Produto" + cProduto + " atualizado com sucesso!")
	Else
		ConOut("LEANTRACK /api/integration/products -> Produto" + cProduto + " erro na atualiza��o! -> " + AllTrim(oLeanTrack:cResult))
	EndIf

Return