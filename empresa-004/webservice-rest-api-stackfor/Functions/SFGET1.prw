#Include "PROTHEUS.CH"

/*/{Protheus.doc} SFGET1
Realiza autentica��o do usu�rio no Protheus
@type  User Function
@author Marcos Nat� Santos
@since 24/06/2019
@version 1.0
@param cUser, char, Usu�rio
@param cPsw, char, Senha
@return SFUser, Objeto, Inst�ncia da classe SFUser
/*/
User Function SFGET1(cUser, cPsw)
    Local oSFUser   := Nil
    Local aUser     := {}

    Local cUserId   := ""
    Local cName := ""
    Local cMail := ""

    If !Empty(cUser) .And. !Empty(cPsw)
        PswOrder(2)
        If PswSeek(cUser, .T.)
            If PswName(cPsw)
                aUser := PswRet()

                cUserId := AllTrim(aUser[1][1])
                cUser := AllTrim(aUser[1][2])
                cName := AllTrim(aUser[1][4])
                cMail := AllTrim(aUser[1][14])

                oSFUser := SFUser():New(cUserId, cUser, cName, cMail)
            EndIf
        EndIf
    EndIf

Return oSFUser