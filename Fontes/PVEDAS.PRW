#INCLUDE "Protheus.ch"
#INCLUDE 'TBIConn.ch'
#INCLUDE "AP5Mail.ch"
#INCLUDE "RWMake.ch"   
#INCLUDE "TopConn.ch"  

/*/{Protheus.doc} PVENDAS()
Funcao que monta o painel de vendas.
@author Lucas Oliveira - 5050tech
@since 06/11/2023
/*/

User Function PVENDAS()

Private oGroup1
Private oGroup2
Private oGroup3
Private ctext1 := "Vendas"
Private ctext2 := "Valores"
Private ctext3 := "Mensagem"
Private oFont
Private oFont2
Private oSay1 //Produto
Private oSay2 //Descricao
Private oSay3 //Placa do veiculo
Private oSay4 //Cacamba
Private oSay5 //Pedido de vendas
Private oSay6 //Grupo
Private oSay7 //Ticket
Private oSay8 //Peso Bruto
Private oSay9 //Tara
Private oSay10 //Peso Cacamba
Private oSay11 //Peso Liquido
Private oSay12 //Balanca
Private oSay13 //Descri��o Cliente do pedido de vendas
Private oSayOPER //Codigo do operador
Private oSayID
Private oSayMSG

Private oDlg
Private oGet1
Private cGet1 := SPACE(TamSX3("B1_COD")[1])
Private oGet2
Private cGet2 := SPACE(TamSX3("B1_DESC")[1])
Private oGet3
Private cGet3 := SPACE(7)
Private oGet4
Private cGet4 := SPACE(3)
Private oGet5
Private cGet5 := SPACE(TamSX3("C5_NUM")[1])
Private oGet6
Private cGet6 := SPACE(TamSX3("B1_GRUPO")[1])
Private oGet7
Private cGet7 := SPACE(12)
Private oGet8
Private nGet8 := 0
Private oGet9
Private nGet9 := 0
Private oGet10
Private nGet10 := 0
Private oGet11
Private nGet11 := 0
Private oGetOPER
Private cGetOPER := SPACE(TamSX3("ZZL_IDOPER")[1])
Private oGet13
Private cGet13 := SPACE(40)

Private lDigPeso := SuperGetMV("HZ_DIGIPES", .F., .F.) // Habilita digitacao do peso Liquido - Balanca UTM - Rodrigo Moraes | Compila | 21/07/2022
Private aBlUtm := {"1=Balanca 01","2=Balanca 02","3=Balanca 03","4=Balanca 04","5=Balanca 05","6=Balanca 06","7=Balanca 07","8=Balanca 08","9=Balanca 09"}
Private oComboBl
Private oComboID
Private cBalUTM := ""
Private cIDUTM := ""
Private cNumTkt := SuperGetMV("HZ_UTMTKT", .F., .F.)
Private cNumBkp
Private cMSGRJ
Private cButton := "QPushButton { background: #35ACCA; border: 1px solid #096A82;outline:0; border-radius: 5px; font: normal 12px Arial; SC6ding: 6px;color: #ffffff;} QPushButton:pressed {background-color: #3AAECB;border-style: inset; border-color: #35ACCA; color: #ffffff; }"
Private oButton1
Private oButton2

cNumTkt := cNumTkt+1
cNumBkp := cNumTkt //Guardo o valor atualizado para mudar no parametro caso confirmado a inclusao do ticket
cNumTkt := "66" + StrZero(cNumTkt, 10)

oFont := TFont():New('Arial Black',,-10,.T.)
oFont2 := TFont():New('Arial Black',,-14,.T.)

cGetOPER := Posicione('ZZL', 2, FWxFilial('ZZL') + __cUserId, 'ZZL_IDOPER')

TELASTK()

RETURN


Static Function TELASTK()

//Local cOper := Posicione("ZZL",1,xFilial("ZZL")+cGetOPER,"ZZL_NUSER")

DEFINE MSDIALOG oDlg TITLE "Painel Vendas" FROM 000,000 TO 650,690 PIXEL 

oGroup1:= TGroup():New(10,10,107,335, ctext1 ,oDlg,,,.T.)
oGroup2:= TGroup():New(108,10,210,335, ctext2 ,oDlg,,,.T.)
oGroup3:= TGroup():New(220,10,270,335, ctext3 ,oDlg,,,.T.)

//GRUPO 1
oSay3:= TSay():New(20,25,{||'Placa do veiculo:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet3:= TGet():New(18,75,bSETGET(cGet3),oGroup1,100,010,"@R !!!-!!!!",,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
oGet3:cF3 := 'ZZKVEI'

oSay5:= TSay():New(35,25,{||'Pedido de Vendas:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet5:= TGet():New(33,78,bSETGET(cGet5),oGroup1,50,010,,/*bValid*/,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
oGet5:cF3 := 'SC5'

oSay13:= TSay():New(50,25,{||'Nome Cliente:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet13:= TGet():New(48,75,bSETGET(cGet13),oGroup1,200,010,,/*bValid*/,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay1:= TSay():New(65,25,{||'Produto:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet1:= TGet():New(63,60,bSETGET(cGet1),oGroup1,100,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
oGet1:cF3 := 'SB1UTM'

oSay2:= TSay():New(80,25,{||'Descri��o:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet2:= TGet():New(78,60,bSETGET(cGet2),oGroup1,200,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay4:= TSay():New(95,25,{||'Ca�amba:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet4:= TGet():New(93,60,bSETGET(cGet4),oGroup1,50,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
oGet4:cF3 := 'ZZKCCB'

oSay7:= TSay():New(20,200,{||'Ticket:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet7:= TGet():New(18,230,bSETGET(cNumTkt),oGroup1,100,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay6:= TSay():New(65,200,{||'Grupo:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet6:= TGet():New(63,230,bSETGET(cGet6),oGroup1,50,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

//GRUPO 2
oSay8:= TSay():New(115,25,{||'Peso Bruto (KG):'},oGroup2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet8:= TGet():New(113,80,bSETGET(nGet8),oGroup2,50,010,"@E 9,999,999.9999",,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay9:= TSay():New(135,25,{||'Tara (KG):'},oGroup2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet9:= TGet():New(133,80,bSETGET(nGet9),oGroup2,50,010,"@E 9,999,999.9999",,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay10:= TSay():New(155,25,{||'Ca�amba (KG):'},oGroup2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet10:= TGet():New(153,80,bSETGET(nGet10),oGroup2,50,010,"@E 9,999,999.9999",,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay11:= TSay():New(175,25,{||'Peso L�quido (KG):'},oGroup2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet11:= TGet():New(173,80,bSETGET(nGet11),oGroup2,50,010,"@E 9,999,999.9999",,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay12:= TSay():New(195,25,{||'Balan�a:'},oGroup2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oComboBL:= tComboBox():New(193,80,{|u|if(PCount()>0,cBalUTM:=u,cBalUTM)},aBlUtm,55,010,oGroup2,,{|| },,,,.T.,,,,,,,,,'cBalUTM')

//Botoes
oButton1 := TButton():New( 275, 010, "Mais Vendas",oDlg,{|| "", IIF( VALTYPE(oDlg) == "O", oDlg:Refresh(),.T.)}, 060, 020,,,.F.,.T.,.F.,,.F.,,,.F. ) 
oButton1:SetCss(cButton)

oButton2 := TButton():New( 300, 010, "Finalizar Vendas",oDlg,{|| "", IIF( VALTYPE(oDlg) == "O", oDlg:Refresh(),.T.)}, 060, 020,,,.F.,.T.,.F.,,.F.,,,.F. ) 
oButton2:SetCss(cButton)

@ 287,142 Button "Pesar"             Size 060,020  ACTION( U_UTMpesoV(), oGet11:SetFocus(), IIF( VALTYPE(oDlg) == "O", oDlg:Refresh(), .T. ))   PIXEL OF oDlg
@ 275,275 Button "Confirmar"         Size 060,020  ACTION( MsgRun( "Processando . . .","Aguarde . . .",{|| OKUTMV(@cGet1,@nGet11) }),oGet11:SetFocus(),IIF(VALTYPE(oDlg) == "O", oDlg:Refresh(),.T.))   PIXEL OF oDlg
@ 300,275 Button "Sair"              Size 060,020  ACTION( oDlg:End())   PIXEL OF oDlg

oGet1:bValid	:= {|| !Empty(cGet1) .AND. (ExistCpo("SB1",cGet1))  }
oGet1:bvalid	:= {|| (cGet2  := Posicione("SB1",1,xFilial("SB1")+cGet1,"B1_DESC")), (cGet6  := Posicione("SB1",1,xFilial("SB1")+cGet1,"B1_GRUPO")) }
oGet3:bvalid	:= {|| (nGet9  := Posicione("ZB6",1,xFilial("ZB6")+cGet3,"ZB6_TARA")) }
oGet5:bvalid	:= {|| (cGet13 := Posicione("SC5",1,xFilial("SC5")+cGet5,"C5_CLIENTE")), (cGet13 := Posicione("SA1",1,"        " + ALLTRIM(cGet13) + "01","A1_NOME")), FILPROD() }
oGet2:Refresh()
oGet6:Refresh()
oGet9:Refresh()
oGet13:Refresh()
oGet2:bWhen     := {|| .F. }
oGet6:bWhen     := {|| .F. }
oGet7:bWhen     := {|| .F. }
oGet8:bWhen     := {|| .F. }
oGet9:bWhen     := {|| .F. }
oGet10:bWhen     := {|| .F. }
oGet11:bWhen    := {|| lDigPeso }

ACTIVATE MSDIALOG oDlg CENTERED
    
Return 


//*****************************************************************Func�es Auxiliares*********************************************************************************


/*/
	{Protheus.doc} Função para filtrar só os produtos que estão no pedido de vendas escolhido no cGet5
/*/
Static Function FILPROD()

    Local cQuery

    cQuery := "SELECT C6_ITEM,C6_PRODUTO FROM "
    cQuery += RetSqlName("SC6")+ " AS SC6 "
    cQuery += " WHERE SC6.D_E_L_E_T_ = ' ' AND SC6.C6_NUM = '"+ALLTRIM(cGet5)+"'"
    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMP14", .F., .T.)

    oGet5:cF3 := 'TMP14'

Return

/*/
	{Protheus.doc} Leitura do Peso informado na UTM  
/*/
User Function UTMpesoV()

Local nTentaPeso	:= GetMv("HZ_QTDLERP",.F.,20) //| Quantidade de tentativas para leitura do Peso
Local nPesoLido
LocaL nI
Local cVeicIN

Default cBalUTM := ""

oSayMSG:= TSay():New(230,25,{||cMSGRJ},oGroup3,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)

IF !EMPTY( cGet1 )
	If SB1->B1_GRUPO == 'UCCB' //Se estiver pesando a cacamba

		FOR nI := 1 to nTentaPeso 
				
			nPesoLido := Round( Val( U_LerPeso( cBalUTM ) ), 0 )  

			If nPesoLido > 0
				Exit
			EndIf
			Sleep(200)
		NEXT nI

		nGet10 := nPesoLido
        nGet11 := nGet10
		oGet10:Refresh()
        oGet11:Refresh()
        cMSGRJ := 'Ser� gerado ticket da ca�amba'
        oSayMSG:Refresh()

    Elseif SB1->B1_GRUPO == 'UVEI' //Se estiver pesando o veiculo
        IF !EMPTY(cGet3)

            IF EMPTY( cGet4 )
                cMSGRJ := 'Ser� gerado ticket de ve�culo'
            ELSE
                cMSGRJ := 'Ser� gerado ticket de ve�culo + ca�amba'
            ENDIF

            FOR nI := 1 to nTentaPeso 
                
                nPesoLido := Round( Val( U_LerPeso( cBalUTM ) ), 0 )  

                If nPesoLido > 0
                    Exit
                EndIf
                Sleep(200)

            NEXT nI

            nGet8 := nPesoLido
            nGet11 := nGet8 - nGet9 - nGet10
            oGet8:Refresh()
            oGet11:Refresh()

            cVeicIN := Posicione('ZB6', 1, FWxFilial('ZB6') + cGet3, 'ZB6_VEIIN')

            IF cVeicIN == 'S'
                IF MSGYESNO("O ve�culo � pr�prio, deseja atualizar o peso no cadastro de ve�culos?")
                    RecLock("ZB6", .F.)
                    ZB6->ZB6_TARA := nGet8
                    ZB6->(MsUnlock())
                    nGet9 := nGet8
                    oGet9:Refresh()
                    nGet11 := nGet8 - nGet9 - nGet10
                    oGet11:Refresh()
                ENDIF
            ENDIF
            oSayMSG:= TSay():New(230,25,{||cMSGRJ},oGroup3,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
        ELSE
            MSGALERT( "Placa do ve�culo n�o pode ser vazio", "Aten��o" )
        ENDIF

	Else //Se estiver pesando reciclado 

        cMSGRJ := 'Ser� gerado a venda do reciclado: '+ cGet2
        oSayMSG:= TSay():New(230,25,{||cMSGRJ},oGroup3,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
		FOR nI := 1 to nTentaPeso 
			
			nPesoLido := Round( Val( U_LerPeso( cBalUTM ) ), 0 )  

			If nPesoLido > 0
				Exit
			EndIf
			Sleep(200)
		NEXT nI

        nGet8 := nPesoLido
        nGet11 := nGet8 - nGet9 - nGet10
        oGet8:Refresh()
        oGet11:Refresh()
        oSayMSG:Refresh()
	EndIf
ELSE
    MSGALERT( "O campo produto n�o pode ser vazio", "Aten��o" )
    oGet1:SetFocus()
ENDIF
Return()



/*/
	{Protheus.doc} OKUTMV() - Geracao da Ordem de Producao e Apontamento da OP - UTM  
/*/

Static Function OKUTMV(cGet1,nGet11)
    
	Local lRet 		:= .F.
    Local cVeicIN
	Private lmsErroAuto := .F.

    //Se for Veiculo ou cacamba preciso apenas cadastrar o ticket de pesagem e nao posso criar OP e fazer apontamentos.
    IF SB1->B1_GRUPO == 'UVEI' .OR. SB1->B1_GRUPO == 'UCCB'

        DBSELECTAREA("ZZK")
        DBSETORDER(2)
        IF DBSEEK(FWxFilial('ZZK') + cGet6 + cGet3 + cGet4 + "D") .AND. nGet8 = 0
            IF MSGYESNO( "J� existe ticket desse veiculo/ca�amba com status dispon�vel, deseja EXCLUIR o ticket?", "Excluir Ticket" )
                RecLock("ZZK", .F.)    

                ZZK->ZZK_STATUS := "C"
                ZZK->ZZK_IDOCAN := cGetOPER
                ZZK->(MsUnlock())

                //Limpo todos os campos para pr�xima opera��o
                cGet1 := SPACE(TamSX3("B1_COD")[1])
                cGet2 := SPACE(TamSX3("B1_DESC")[1])
                cGet3 := SPACE(7)
                cGet4 := SPACE(3)
                cGet5 := SPACE(TamSX3("C2_NUM")[1])
                cGet6 := SPACE(TamSX3("B1_GRUPO")[1])
                cGet7 := SPACE(12)
                nGet8 := 0
                nGet9 := 0
                nGet10 := 0
                nGet11 := 0
                oGet1:Refresh()
                oGet2:Refresh()
                oGet3:Refresh()
                oGet4:Refresh()
                oGet5:Refresh()
                oGet6:Refresh()
                oGet7:Refresh()
                oGet8:Refresh()
                oGet9:Refresh()
                oGet10:Refresh()
                oGet11:Refresh()
            ENDIF

        ELSE
            cVeicIN := Posicione('ZB6', 1, FWxFilial('ZB6') + cGet3, 'ZB6_VEIIN')

            RecLock("ZZK", .T.)
                ZZK->ZZK_FILIAL := FWxFilial('ZZK')
                ZZK->ZZK_IDTKT := cNumTkt
                ZZK->ZZK_IDPROC := "P"
                ZZK->ZZK_IDOPER := "E"
                ZZK->ZZK_CODPRO := cGet1
                ZZK->ZZK_GPPROD := cGet6
                ZZK->ZZK_PLVEIC := cGet3
                ZZK->ZZK_IDCCB := cGet4
                ZZK->ZZK_PV := ""
                ZZK->ZZK_OP := cGet5
                ZZK->ZZK_PBRUTO := nGet8
                ZZK->ZZK_PCCB := nGet10
                ZZK->ZZK_PVEIC := nGet9
                ZZK->ZZK_PPROD := nGet11
                ZZK->ZZK_TLVEND := 0
                ZZK->ZZK_STATUS := "D"
                ZZK->ZZK_VEICIN := IIF( cVeicIN = "S", "S", "N" )
                ZZK->ZZK_IDMVEN := ""
                ZZK->ZZK_IDVINC := ""
                ZZK->ZZK_IDVEND := ""
                ZZK->ZZK_DTENT := Date()
                ZZK->ZZK_HRENT := Time()
                ZZK->ZZK_DTSAI := CTOD(" / / ")
                ZZK->ZZK_HRSAI := ""
                ZZK->ZZK_IDOENT := cGetOPER
                ZZK->ZZK_IDOSAI := ""
                ZZK->ZZK_IDOALT := ""
                ZZK->ZZK_IDOCAN := ""
                ZZK->ZZK_IDOEST := ""
                //ZZK->ZZK_TKTMAN := ""
                ZZK->ZZK_DTVCAN := CTOD(" / / ")
                ZZK->ZZK_HRVCAN := ""
                ZZK->ZZK_DTEEST := CTOD(" / / ")
                ZZK->ZZK_HREEST := ""
                ZZK->ZZK_DTCPES := CTOD(" / / ")
                ZZK->ZZK_HRCPES := ""
                ZZK->ZZK_DTALT := CTOD(" / / ")
                ZZK->ZZK_HRALT := ""
                ZZK->ZZK_DTSINC := CTOD(" / / ")
                ZZK->(MsUnlock())

            PUTMV("HZ_UTMTKT",cNumBkp)
            //Limpo todos os campos para pr�xima opera��o
            cGet1 := SPACE(TamSX3("B1_COD")[1])
            cGet2 := SPACE(TamSX3("B1_DESC")[1])
            cGet3 := SPACE(7)
            cGet4 := SPACE(3)
            cGet5 := SPACE(TamSX3("C2_NUM")[1])
            cGet6 := SPACE(TamSX3("B1_GRUPO")[1])
            cGet7 := SPACE(12)
            nGet8 := 0
            nGet9 := 0
            nGet10 := 0
            nGet11 := 0
            cNumBkp++
            cNumTkt := cNumBkp
            cNumTkt := "66" + StrZero(cNumTkt, 10)
            oGet1:Refresh()
            oGet2:Refresh()
            oGet3:Refresh()
            oGet4:Refresh()
            oGet5:Refresh()
            oGet6:Refresh()
            oGet7:Refresh()
            oGet8:Refresh()
            oGet9:Refresh()
            oGet10:Refresh()
            oGet11:Refresh()
            cMSGRJ := ""
            oSayMSG:Refresh()
        ENDIF
    ELSE
       
    ENDIF

Return( lRet, nGet11, cGet1 )
//fim bloco [Mauro Nagata, Orizon, 20220720]




