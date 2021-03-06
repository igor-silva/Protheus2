#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//+--------------------------------------------------------------------+
//| Autor | Marcos Nat� | Data | 04.05.2017 	       			       |
//+--------------------------------------------------------------------+
//| Obejtivo| Incluir revis�es de cores do produto na O.P.	       	   |
//+--------------------------------------------------------------------+
//| Campo | Utilizado na valida��o do campo C2_PRODUTO      	       |
//+--------------------------------------------------------------------+

User Function REVCORES()
	Local lRet := .T.
	
	cQry := "SELECT MAX(SZF.ZF_REVISAO) REV"
	cQry += "FROM SZF010 SZF "
	cQry += "INNER JOIN SB1010 SB1 ON SZF.ZF_CODCOR = SB1.B1_XCORTMP "
	cQry += "WHERE SZF.D_E_L_E_T_ = ' ' "
	cQry += "AND SB1.B1_COD = '"+M->C2_PRODUTO+"' "
	cQry += "AND SZF.ZF_APROV = 'S' "

	cQry:= ChangeQuery(cQry)
	If Select("QRYA") > 0
		QRYA->(dbCloseArea())
	EndIf

	TCQUERY cQry NEW ALIAS "QRYA"
	
	If QRYA->REV = 0
		MsgAlert("Revis�o da cor da tampa n�o encontrada. A amarra��o de COR x COMPONENTE est� cadastrada ou liberada ?")
		Return .F.
	EndIf
	
	//Atribui��o c�digo da cor da tampa
	M->C2_XRVCAP := QRYA->REV

	cQry := "SELECT MAX(SZF.ZF_REVISAO) REV"
	cQry += "FROM SZF010 SZF "
	cQry += "INNER JOIN SB1010 SB1 ON SZF.ZF_CODCOR = SB1.B1_XCORCRP "
	cQry += "WHERE SZF.D_E_L_E_T_ = ' ' "
	cQry += "AND SB1.B1_COD = '"+M->C2_PRODUTO+"' "
	cQry += "AND SZF.ZF_APROV = 'S' "

	cQry:= ChangeQuery(cQry)
	If Select("QRYB") > 0
		QRYB->(dbCloseArea())
	EndIf

	TCQUERY cQry NEW ALIAS "QRYB"
	
	If QRYB->REV = 0
		MsgAlert("Revis�o da cor do corpo n�o encontrada. A amarra��o de COR x COMPONENTE est� cadastrada ou liberada ?")
		Return .F.
	EndIf
	
	//Atribui��o c�digo cor do corpo
	M->C2_XRVBODY := QRYB->REV

Return lRet