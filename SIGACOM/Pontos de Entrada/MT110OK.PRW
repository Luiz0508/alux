#Include "totvs.ch"
#Include "topconn.ch"
#Include "tbiconn.ch"

/* trocar pra SC7 A VALIDAÇÃO */
User Function  MT110TOK()
	Local cQuery:=''
	Local _cFilial:=FwcodFil()
	Local _cCodCc:=''
	Local _cRateio := ''
	//Local nPosItem    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_ITEM'})
	Local lValido := .T.


	_cNrSolic := cA110Num
	IF Empty(_cNrSolic)
		_cNrSolic:= SC1->C1_NUM 
	EndIf
	_cCodCc:=ALLTRIM(GdFieldGet('C1_CC'))
	_cTipCom:=ALLTRIM(GdFieldGet('C1_EC05DB'))
	_cGrMat:=ALLTRIM(GdFieldGet('C1_EC06DB'))
	_cRateio:=ALLTRIM(GdFieldGet('C1_RATEIO'))

	If Empty(_cCodCc)
	
		If Inclui
			If _cRateio == "2"
				FwAlertWarning("Favor informar o Centro de Custo , favor verificar ")
				lValido := .F.
			endif
		Else
			cQuery := " SELECT * FROM "+RetSQLName("SCX")
			cQuery += " WHERE CX_FILIAL = '"+_cFilial+"'
			cQuery += " AND CX_SOLICIT = '"+_cNrSolic+"'

			TcQuery cQuery New Alias "XSCX"

			IF XSCX->(Eof())
				FwAlertWarning("Favor informar o Centro de Custo , favor verificar ")
				XSCX->(DBCLOSEAREA())
				lValido := .F.
			EndIf
			XSCX->(DBCLOSEAREA())
		EndIf
	EndIf

Return(lValido)


/*
se estiver com o contrato preenchido, calculamos 
se (total_do_contrato-total_utilizado(soma sc1)-total solicitação em digitação<0) {
mensagem: Sem saldo disponível no contrato selecionado
return .f.
}
*/
