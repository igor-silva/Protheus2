#Include "Protheus.ch"
#Include "Topconn.ch"

//+--------------------------------------------------------------------+
//| Fun��o | VALIDCX | Autor | Marcos Nat� | Data | 07/04/2017	       |
//+--------------------------------------------------------------------+
//| Descr. | Valida��o no campo Z1_VOLUME        	                   |
//+--------------------------------------------------------------------+

User Function VALIDCX(cVolume)
	Local cOp := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN

	cQry := "SELECT Z1_VOLUME VOLUME FROM SZ1010
	cQry += "WHERE D_E_L_E_T_ = ' ' "
	cQry += "AND Z1_ORDPROD = '"+cOp+"' "
	cQry += "ORDER BY Z1_VOLUME "

	cQry:= ChangeQuery(cQry)
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf

	TCQUERY cQry NEW ALIAS "QRY"

	While QRY->(!EOF())
		If cVolume == QRY->VOLUME .And. !Empty(QRY->VOLUME)
			MsgAlert("Volume j� existe", "Alerta")
			Return .F.
		EndIf
		QRY->(DbSkip())
	EndDo

	If At(".", cVolume) != 0
		MsgAlert("Campo com carater especial", "Alerta")
		Return .F.
	ElseIf At("*", cVolume) != 0
		MsgAlert("Campo com carater especial", "Alerta")
		Return .F.
	ElseIf At("/", cVolume) != 0
		MsgAlert("Campo com carater especial", "Alerta")
		Return .F.
	ElseIf At("+", cVolume) != 0
		MsgAlert("Campo com carater especial", "Alerta")
		Return .F.
	ElseIf At("-", cVolume) != 0
		MsgAlert("Campo com carater especial", "Alerta")
		Return .F.
	ElseIf At(",", cVolume) != 0
		MsgAlert("Campo com carater especial", "Alerta")
		Return .F.
	EndIf

Return .T.