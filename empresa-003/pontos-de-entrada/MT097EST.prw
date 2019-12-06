#Include "Protheus.ch"

/*/{Protheus.doc} MT097EST

LOCALIZA��O : Function A097ESTORNA - Fun��o da Dialog que estorna a
libera��o dos documentos com al�ada. 

EM QUE PONTO : O ponto se encontra no inicio da fun��o A097ESTORNA,
n�o passa parametros e n�o envia retorno, usado conforme necessidades do 
usuario para diversos fins.

@author 	Marcos Nat� Santos
@since 		09/08/2018
@version 	12.1.17
@return 	Nil
/*/
User Function MT097EST()
    Local lPROCPR  := SuperGetMV("MV_XPROPR",.F.,.T.)

    /*
	�������������������������������������������������������������������������͹��
	���Desc.     � Customiza��o Titulo Provisorio           				  ���
	�������������������������������������������������������������������������͹��
	*/
	If lPROCPR
        //-- Exclui T�tulos Provis�rios
		MsgRun("Verificando Titulos Provisorio ","Aguarde...", {||U_ExclTitPR(SCR->CR_FILIAL,AllTrim(SCR->CR_NUM),'PR ',,)})
	EndIf

Return