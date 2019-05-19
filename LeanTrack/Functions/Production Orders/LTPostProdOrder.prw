#Include "Protheus.ch"
#Include "RestFul.ch"

/*/{Protheus.doc} LTPostProdOrder

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
User Function LTPostProdOrder

Return