#Include "Protheus.ch"
#Include "RestFul.ch"

/*/{Protheus.doc} LTPostOrder

DESCRI��O DOS PAR�METROS
-----------------------------------------------------------------------------------------------
Campo	    |  Regras	                            |  Detalhes                               |
-----------------------------------------------------------------------------------------------
produto	    |  obrigat�rio, deve existir no banco	|  C�digo de identifica��o do produto     |
codigo	    |  obrigat�rio, deve ser �nico	        |  Identificador da OP                    |
quantidade  |  obrigat�rio, n�merico	            |  Quantidade a ser produzida             |
dt_inicio	|  obrigat�rio, formato: d/m/Y H:i:s	|  Data de in�cio da OP                   |
dt_fim	    |  opcional, formato: d/m/Y H:i:s	    |  Data de fim da OP                      |
dt_emissao  |  obrigat�rio, formato: d/m/Y H:i:s	|  Data de Emiss�o da OP                  |
equipamento |  opcional, deve existir no banco	    |  C�digo de identifica��o do equipamento |
-----------------------------------------------------------------------------------------------

DESCRI��O DA RESPOSTA
----------------------------------------------
Campo	            |  Detalhes              |
----------------------------------------------
total_count	        |  Quantidade Processada |
rows_created_count	|  Quantidade Cadastrada |
rows_updated_count	|  Quantidade Atualizada |
rows_failed_count	|  Quantidade que Falhou |
rows_failed	        |  Lista de falhas       |
----------------------------------------------

@author 	Marcos Nat� Santos
@since 		19/05/2019
@version 	12.1.17
/*/
User Function LTPostOrder(cProduto, cOP, nQtd, dDtIni, dDtFim, dDtEmis)
    Local cUrl        := SuperGetMv("LT_URL", .F., "https://demo.leantrack.com.br")
	Local oLeanTrack  := FWRest():New(cUrl)
	Local cAuthToken  := U_LTGetToken()
	Local aHeader     := {}
	Local cJSON       := ""
    Local oJsonResult := JsonObject():new()

    Default cProduto := ""
    Default cOP      := ""
    Default nQtd     := 0
    Default dDtIni   := Space(8)
    Default dDtFim   := Space(8)
    Default dDtEmis  := Space(8)

    aAdd(aHeader, "Content-Type: application/json")
	aAdd(aHeader, "Authorization: Bearer " + cAuthToken)

    cJSON += '[{'
    cJSON += '"produto": "'+ cProduto +'",'
    cJSON += '"codigo": "'+ cOP +'",'
    cJSON += '"quantidade": '+ cValToChar(nQtd) +','
    cJSON += '"dt_inicio": "'+ DTOC(dDtIni) +' 00:00:00",'
    cJSON += '"dt_fim": "'+ DTOC(dDtFim) +' 00:00:00",'
    cJSON += '"dt_emissao": "'+ DTOC(dDtEmis) +' 00:00:00",'
    cJSON += '"equipamento": ""'
    cJSON += '}]'

	oLeanTrack:setPath("/api/integration/production-orders")
	oLeanTrack:SetPostParams(cJSON)

	If oLeanTrack:Post(aHeader)
        oJsonResult:fromJSON( oLeanTrack:GetResult() )
        MsgInfo( oJsonResult:GetJsonText("rows_failed_count") )

		ConOut("LEANTRACK /api/integration/production-orders -> Ordem "+ cOP +" atualizada com sucesso!")
	Else
        MsgInfo( oLeanTrack:GetLastError() )
		ConOut("LEANTRACK /api/integration/production-orders -> Ordem "+ cOP +" erro na atualiza��o! -> " + AllTrim(oLeanTrack:cResult))
	EndIf

    FreeObj(oJsonResult)
Return