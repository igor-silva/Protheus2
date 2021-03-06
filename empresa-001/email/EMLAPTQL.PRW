#Include "TOTVS.CH"
#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "AP5MAIL.CH"

//+--------------------------------------------------------------------+
//| Fun��o | EMLAPTQL | Autor | Marcos Nat� | Data | 04/04/2017 	   |
//+--------------------------------------------------------------------+
//| Descr. | Email enviado com dados de apontamentos para o armaz�m 98.|
//+--------------------------------------------------------------------+
//| Uso    | Qualidade                                                 |
//+--------------------------------------------------------------------+

User Function EMLAPTQL()

	Local oServer := Nil
	Local oMessage := Nil
	Local nErr := 0
	Local cPopAddr  := "pop.genix.ind.br"      // Endereco do servidor POP3
	Local cSMTPAddr := "smtp.genix.ind.br"     // Endereco do servidor SMTP
	Local cPOPPort  := 110                    // Porta do servidor POP
	Local cSMTPPort := 587                    // Porta do servidor SMTP
	Local cUser     := "protheus@genix.ind.br"     // Usuario que ira realizar a autenticacao
	Local cPass     := "senha@prot"             // Senha do usuario
	Local nSMTPTime := 60                     // Timeout SMTP
	Local cQL       := Chr(13)+Chr(10)
	Local cRemoteip :=  Getclientip()
	Local cRemoteComputer :=  GetComputerName()

	Local cCod := M->H6_PRODUTO
	Local cDesc := M->H6_XDESC
	Local cLote := M->H6_LOTECTL
	Local cOp := M->H6_OP
	Local dDtFab := Posicione("SZ1", 3, xFilial("SZ1") + M->H6_OP, "Z1_DTFAB")
	Local dDtVal := Posicione("SZ1", 3, xFilial("SZ1") + M->H6_OP, "Z1_DTVALID")
	Local nQtdProd := M->H6_QTDPROD

	// Query que realiza a contagem de caixas produzidas pela ordem de produ��o
	cQry := "SELECT COUNT(Z1_VOLUME) VOLUMES FROM SZ1010 "
	cQry += "WHERE D_E_L_E_T_ = ' ' "
	cQry += "AND Z1_ORDPROD = '"+M->H6_OP+"' "

	cQry:= ChangeQuery(cQry)
	If Select("QRY") > 0
		QRY->(dbCloseArea())
	EndIf

	TCQUERY cQry NEW ALIAS "QRY"

	// Instancia um novo TMailManager
	oServer := tMailManager():New()

	// Usa SSL na conexao
	oServer:setUseSSL(.F.)

	// Inicializa
	oServer:init(cPopAddr, cSMTPAddr, cUser, cPass, cPOPPort, cSMTPPort)

	// Define o Timeout SMTP
	If oServer:SetSMTPTimeout(nSMTPTime) != 0
		conout("[ERROR]Falha ao definir timeout")
		Return .F.
	EndIf

	// Conecta ao servidor
	nErr := oServer:smtpConnect()
	If nErr <> 0
		conOut("[ERROR]Falha ao conectar: " + oServer:getErrorString(nErr))
		oServer:smtpDisconnect()
		Return .F.
	EndIf

	// Realiza autenticacao no servidor
	nErr := oServer:smtpAuth(cUser, cPass)
	If nErr <> 0
		conOut("[ERROR]Falha ao autenticar: " + oServer:getErrorString(nErr))
		oServer:smtpDisconnect()
		Return .F.
	EndIf

	// Cria uma nova mensagem (TMailMessage)
	oMessage := tMailMessage():new()
	oMessage:clear()
	oMessage:cFrom    := "protheus@genix.ind.br"
	oMessage:cTo      := getMV('MV_EMLAPTQL')
	oMessage:cCC      := ""
	oMessage:cBCC     := "logs@genix.ind.br"
	oMessage:cSubject := "..::Notifica��o Autom�tica - Protheus - Entrada de Produto na Qualidade::.."

	// cBody com o corpo do e-mail
	cBody :=	'<html>'
	cBody +=	'<head>'
	cBody +=	'<meta http-equiv="Content-Type" content="text/html charset=ISO-8859-1">'
	cBody +=	'</head>'
	cBody +=	'<body>'
	cBody +=	'<div marginheight="0" marginwidth="0">'
	cBody +=	'<table border="0" cellpadding="0" cellspacing="0">'
	cBody +=	'<tbody>'
	cBody +=	'<tr><td><font face="arial" size="2"><center><b><u>NOTIFICA��O AUTOM�TICA</u></b><br><br><br></center></font></td></tr>'
	cBody +=	'<tr><td><font face="arial" size="2">Prezado Colaborador.<br><br>'
	cBody +=	'Este e-mail tem o intuito de avis�-lo que um novo produto precisa de aprova��o na Qualidade.<br><br><br>'
	cBody +=	'<b>INFORMA��ES:</b><br><br>'
	cBody +=	'<b>Produto: </b>' + cCod + '<br><br>'
	cBody +=	'<b>Descri��o: </b>' + cDesc + '<br><br>'
	cBody +=	'<b>Lote: </b>' + cLote + '<br><br>'
	cBody +=	'<b>O.P.: </b>' + cOp + '<br><br>'
	cBody +=	'<b>Data Fabrica��o: </b>' + DTOC(dDtFab) + '<br><br>'
	cBody +=	'<b>Data Validade: </b>' + DTOC(dDtVal) + '<br><br>'
	cBody +=	'<b>Data Apontamento: </b>' + DTOC(dDataBase) + '<br><br>'
	cBody +=	'<b>Hora Apontamento: </b>' + Time() + '<br><br>'
	cBody +=	'<b>Quantidade: </b>' + cValToChar(nQtdProd) + '<br><br>'
	cBody +=	'<b>Volumes: </b>' + cValToChar(QRY->VOLUMES) + '<br><br></font>'
	cBody += 	'<tr><td><hr></td></tr>'
	cBody +=   	'<tr><td><font face = "arial" size="2" color="#D3D3D3">Apontando por: </font>' + cUsername + '</td></tr><br>'
	cBody +=   	'<tr><td><font face = "arial" size="2" color="#D3D3D3">Enviado do Computador: </font>' + cRemoteComputer + '</td></tr><br>'
	cBody +=   	'<tr><td><font face = "arial" size="2" color="#D3D3D3">Com endere�o IP: </font>' + cRemoteip + '</td></tr><br>'
	cBody +=   	'<tr><td><font face = "arial" size="2" color="#D3D3D3">Enviado Dia: </font>'  + DtoC(dDataBase) + ' as ' + Time() + '  horas. </td></tr><br>'
	cBody +=   	'<tr><td><hr></td></tr>'
	cBody +=	'<tr><td><font face="arial" size="2"><center>***Este � um e-mail autom�tico, favor n�o responder.***</center></font></td></tr>'
	cBody +=	'</table><br>'
	cBody +=	'<hr />'
	cBody +=	'<br>'
	cBody +=	'<td><img src="http://200.233.202.193/meioambiente.png"><font color = "green">   Antes de imprimir pense em seu compromisso com o Meio Ambiente.</font></td>'
	cBody +=	'</body>'
	cBody +=	'</html>'
	oMessage:cBody := cBody

	// Envia a mensagem
	nErr := oMessage:send(oServer)
	If nErr <> 0
		conout("[ERROR]Falha ao enviar: " + oServer:getErrorString(nErr))
		oServer:smtpDisconnect()
		Return .F.
	EndIf

	// Disconecta do Servidor
	oServer:smtpDisconnect()

Return .T.