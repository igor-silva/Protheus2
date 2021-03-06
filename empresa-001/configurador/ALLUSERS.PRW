#Include "Protheus.ch"
#Include "Totvs.ch"

//+--------------------------------------------------------------------+
//| Rotina | REPTUSER | Autor | Marcos Nat� | Data | 13.05.2016 	   |
//+--------------------------------------------------------------------+
//| Descr. | Gera relat�rio de todos usu�rios do sistema               |
//+--------------------------------------------------------------------+
//| Uso | Departamento de Tecnologia da Informa��o                     |
//+--------------------------------------------------------------------+
//| Alterado por Marcos Nat� | Dia 08/02/2017	                       |
//+--------------------------------------------------------------------+

User Function REPTUSER()
	Private oFont10 := TFont():New("ARIAL",9,10,.T.,.F.,5,.T.,5,.T.,.F.) //Fonte 10 Normal
	Private oFont16N := TFONT():New("ARIAL",16,16,,.T.,,,,.T.,.F.) ///Fonte 16 Negrito
	Private oFont12N := TFONT():New("ARIAL",12,12,,.T.,,,,.T.,.F.) ///Fonte 12 Negrito
	Private oFont8 := TFont():New("ARIAL",9,8,.T.,.F.,5,.T.,5,.T.,.F.) //Fonte 8 Normal
	Private oFont10N := TFont():New("ARIAL",9,10,,.T.,,,,.T.,.F.) //Fonte 10 Negrito

	Private oDlg
	Private oPrint
	Private aUsers := {}
	Private cStartPath
	Private nLin := 0
	Private nPag := 1
	Private nTotalUsuarios := 0
	Private nTotalAtivos := 0
	Private nTotalBloqueados := 0
	Private oSay
	Private cParam
	Private oComboBox
	Private aItens := {"1=Ativos", "2=Bloqueados", "3=Ambos"}
	Private aButtons := {}

	oPrint := TMSPrinter():New("")
	oPrint:SetPortrait()
	oPrint:Setup()

	DEFINE DIALOG oDlg TITLE "Informe o tipo de consulta" FROM 000,000 TO 200, 400 PIXEL
	@ 035, 035 SAY oSay PROMPT "Por usu�rios: " SIZE 043, 012 OF oDlg PIXEL
	cParam := aItens[3]
	oComboBox := TComboBox():New(33, 75, {|u|If(PCount()>0, cParam:=u, cParam)},;
	aItens, 100, 20, oDlg,,,,,,.T.,,,,,,,,, "cParam")
	ACTIVATE DIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, {|| oDlg:End(), ProcReport()} , {|| oDlg:End()},, aButtons)
Return

//R�gua para processamento
Static Function ProcReport()
	RptStatus({||RunReport()}, "Consultando dados", "Aguarde...")
Return

//Processamento e valida��es do relat�rio
Static Function RunReport()
	aUsers := AllUsers() //Array com todos usu�rios do sistema
	SetRegua(Len(aUsers))

	For nI := 1 To Len(aUsers)
		If nLin >= 3000
			Roda()
			nI-- //Realinhando o contador de registros
			Loop //Pula para pr�xima p�gina
		ElseIf nLin == 0
			Cabec()
		EndIf

		Do Case
			Case cParam == "1"
			If aUsers[nI][1][17] == .F.
				oPrint:Say(nLin, 150, aUsers[nI][1][1], oFont10)	//Id
				oPrint:Say(nLin, 300, aUsers[nI][1][2], oFont10)	//Usu�rio
				oPrint:Say(nLin, 690, SUBSTR(aUsers[nI][1][12], 1, 23), oFont10)	//Departamento
				//oPrint:Say(nLin, 1500, aUsers[nI][1][13], oFont10)	//Cargo
				oPrint:Say(nLin, 1180, SUBSTR(aUsers[nI][1][22], 7, 6), oFont10)	//Matr�cula
				oPrint:Say(nLin, 1400, IIF(!Empty(SUBSTR(aUsers[nI][1][22], 7, 6)), POSICIONE("SRA", 1, xFilial("SRA") + SUBSTR(aUsers[nI][1][22], 7, 6), "RA_NOME"), ""), oFont10)	//Colaborador
				oPrint:Say(nLin, 2200, "Ativo", oFont10)			//Status
				nTotalUsuarios++ //Contagem geral de todos usu�rios
				nLin += 50 //Espa�o entre resultados
			EndIf
			Case cParam == "2"
			If aUsers[nI][1][17] == .T.
				oPrint:Say(nLin, 150, aUsers[nI][1][1], oFont10)	//Id
				oPrint:Say(nLin, 300, aUsers[nI][1][2], oFont10)	//Usu�rio
				oPrint:Say(nLin, 690, SUBSTR(aUsers[nI][1][12], 1, 23), oFont10)	//Departamento
				//oPrint:Say(nLin, 1500, aUsers[nI][1][13], oFont10)	//Cargo
				oPrint:Say(nLin, 1180, SUBSTR(aUsers[nI][1][22], 7, 6), oFont10)	//Matr�cula
				oPrint:Say(nLin, 1400, IIF(!Empty(SUBSTR(aUsers[nI][1][22], 7, 6)), POSICIONE("SRA", 1, xFilial("SRA") + SUBSTR(aUsers[nI][1][22], 7, 6), "RA_NOME"), ""), oFont10)	//Colaborador
				oPrint:Say(nLin, 2150, "Bloqueado", oFont10)			//Status
				nTotalUsuarios++ //Contagem geral de todos usu�rios
				nLin += 50 //Espa�o entre resultados
			EndIf
			Otherwise
			oPrint:Say(nLin, 150, aUsers[nI][1][1], oFont10)	//Id
			oPrint:Say(nLin, 300, aUsers[nI][1][2], oFont10)	//Usu�rio
			oPrint:Say(nLin, 690, SUBSTR(aUsers[nI][1][12], 1, 23), oFont10)	//Departamento
			//oPrint:Say(nLin, 1500, aUsers[nI][1][13], oFont10)	//Cargo
			oPrint:Say(nLin, 1180, SUBSTR(aUsers[nI][1][22], 7, 6), oFont10)	//Matr�cula
			oPrint:Say(nLin, 1400, IIF(!Empty(SUBSTR(aUsers[nI][1][22], 7, 6)), POSICIONE("SRA", 1, xFilial("SRA") + SUBSTR(aUsers[nI][1][22], 7, 6), "RA_NOME"), ""), oFont10)	//Colaborador
			If aUsers[nI][1][17] == .T.							//Situa��o
				oPrint:Say(nLin, 2150, "Bloqueado", oFont10)
				nTotalBloqueados++ //Contagem dos usu�rios bloqueados
			Else
				oPrint:Say(nLin, 2200, "Ativo", oFont10)
				nTotalAtivos++ //Contagem dos usu�rios ativos
			EndIf
			nTotalUsuarios++ //Contagem geral de todos usu�rios
			nLin += 50 //Espa�o entre resultados
		EndCase

		If nI >= Len(aUsers)
			nLin += 60
			oPrint:Line(nLin, 50, nLin, 2400) //Linha antes dos totais
			nLin += 50
			oPrint:Say(nLin, 150, "Total de usu�rios: " + cValToChar(nTotalUsuarios), oFont10N)
			If cParam == "3"
				oPrint:Say(nLin, 1000, "Total ativos: " + cValToChar(nTotalAtivos), oFont10N)
				oPrint:Say(nLin, 1800, "Total bloqueados: " + cValToChar(nTotalBloqueados), oFont10N)
			EndIf
			nLin += 60
			oPrint:Line(nLin, 50, nLin, 2400) //Linha depois dos totais
			Roda()
		EndIf
		IncRegua()
	Next

	oPrint:Preview()
Return

Static Function Cabec()
	Local nI := 1

	nLin := 50
	oPrint:StartPage() //Inicia uma nova p�gina

	//Buscando endere�o da logo no servidor
	cStartPath := GetPvProfString(GetEnvServer(), "StartPath", "ERROR", GetAdv97())
	cStartPath += IIF(Right(cStartPath, 1) <> "\", "\", "")

	oPrint:SayBitmap(90, 60, cStartPath + "logorel.bmp", 270, 90) //Impress�o da logo
	oPrint:Say(nLin+10, 2100, "P�gina " + cValToChar(nPag), oFont10)
	oPrint:Say(nLin+50, 2100, Time(), oFont10)
	oPrint:Say(nLin+85, 2100, DTOC(dDatabase), oFont10)

	nLin += 100
	oPrint:Say(nLin+0, 850, "RELA��O DE USU�RIOS", oFont16N)
	oPrint:Line(nLin+200, 50, nLin+200, 2400)

	//Define onde come�ar� a impress�o dos dados no relat�rio
	nLin := 400

	//Cabe�alho
	oPrint:Say(nLin, 150, "ID", oFont12N)
	oPrint:Say(nLin, 300, "USU�RIO", oFont12N)
	oPrint:Say(nLin, 690, "DEPARTAMENTO", oFont12N)
	//oPrint:Say(nLin, 1500, "CARGO", oFont12N)
	oPrint:Say(nLin, 1180, "MATR.", oFont12N)
	oPrint:Say(nLin, 1400, "COLABORADOR", oFont12N)
	oPrint:Say(nLin, 2150, "STATUS", oFont12N)

	nLin += 60 //Aumentar o espa�o entre o cabe�alho dos campos e os resultados
Return

Static Function Roda()
	nLin := 3150 //Posiciona o in�cio da impress�o na linha apontada

	oPrint:Line(nLin, 50, nLin, 2400)
	nLin += 20
	oPrint:Say(nLin, 150, "Emitido por: " + UsrFullName(__cUserId), oFont8)
	oPrint:Say(nLin, 1950, DTOC(dDatabase) + " / " + Time(), oFont8)
	nLin += 50
	oPrint:Line(nLin, 50, nLin, 2400)

	nLin := 0
	nPag++

	oPrint:EndPage() //Fim p�gina
Return