#INCLUDE "Protheus.ch"
#INCLUDE 'TBIConn.ch'
#INCLUDE "AP5Mail.ch"
#INCLUDE "RWMake.ch"   
#INCLUDE "TopConn.ch"  

/*/{Protheus.doc} PESTOQ()
Funcao que monta o painel de pesagem de veiculos e controle de estoque.
@author Lucas Oliveira - 5050tech
@since 25/10/2023
/*/

User Function PESTOQ()

Private oGroup1
Private oGroup2
Private oGroup3
Private ctext1 := "Estoque"
Private ctext2 := "Valores"
Private ctext3 := "Mensagem"
Private oFont
Private oFont2
Private oSay1 //Produto
Private oSay2 //Descricao
Private oSay3 //Placa do veiculo
Private oSay4 //Cacamba
Private oSay5 //OP
Private oSay6 //Grupo
Private oSay7 //Ticket
Private oSay8 //Peso Bruto
Private oSay9 //Tara
Private oSay10 //Peso Cacamba
Private oSay11 //Peso Liquido
Private oSay12 //Balanca
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
Private cGet5 := SPACE(TamSX3("C2_NUM")[1])
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

Private lDigPeso := SuperGetMV("HZ_DIGIPES", .F., .F.) // Habilita digitacao do peso Liquido - Balanca UTM - Rodrigo Moraes | Compila | 21/07/2022
Private aBlUtm := {"1=Balanca 01","2=Balanca 02","3=Balanca 03","4=Balanca 04","5=Balanca 05","6=Balanca 06","7=Balanca 07","8=Balanca 08","9=Balanca 09"}
Private oComboBl
Private oComboID
Private cBalUTM := ""
Private cIDUTM := ""
Private cNumTkt := SuperGetMV("HZ_UTMTKT", .F., .F.)
Private cNumBkp
Private cMSGRJ

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

DEFINE MSDIALOG oDlg TITLE "Painel Estoque" FROM 000,000 TO 650,690 PIXEL 

oGroup1:= TGroup():New(10,10,95,335, ctext1 ,oDlg,,,.T.)
oGroup2:= TGroup():New(100,10,210,335, ctext2 ,oDlg,,,.T.)
oGroup3:= TGroup():New(220,10,270,335, ctext3 ,oDlg,,,.T.)

//Operador 
//oSayID:= TSay():New(05,100,{||'Operador:  '+cOper},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)

//GRUPO 1
oSay1:= TSay():New(20,25,{||'Produto:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet1:= TGet():New(18,60,bSETGET(cGet1),oGroup1,100,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
oGet1:cF3 := 'SB1UTM'

oSay2:= TSay():New(35,25,{||'Descrição:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet2:= TGet():New(33,60,bSETGET(cGet2),oGroup1,200,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay3:= TSay():New(50,25,{||'Placa do veiculo:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet3:= TGet():New(48,75,bSETGET(cGet3),oGroup1,100,010,"@R !!!-!!!!",,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
oGet3:cF3 := 'ZZKVEI'

oSay4:= TSay():New(65,25,{||'Caçamba:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet4:= TGet():New(63,60,bSETGET(cGet4),oGroup1,50,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
oGet4:cF3 := 'ZZKCCB'

oSay5:= TSay():New(80,25,{||'OP:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet5:= TGet():New(78,60,bSETGET(cGet5),oGroup1,50,010,,/*bValid*/,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)
oGet5:cF3 := 'SC2'

oSay6:= TSay():New(20,200,{||'Grupo:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet6:= TGet():New(18,230,bSETGET(cGet6),oGroup1,50,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay7:= TSay():New(50,200,{||'Ticket:'},oGroup1,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet7:= TGet():New(48,230,bSETGET(cNumTkt),oGroup1,100,010,,,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

//GRUPO 2
oSay8:= TSay():New(110,25,{||'Peso Bruto (KG):'},oGroup2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet8:= TGet():New(108,80,bSETGET(nGet8),oGroup2,50,010,"@E 9,999,999.9999",,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay9:= TSay():New(130,25,{||'Tara (KG):'},oGroup2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet9:= TGet():New(128,80,bSETGET(nGet9),oGroup2,50,010,"@E 9,999,999.9999",,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay10:= TSay():New(150,25,{||'Caçamba (KG):'},oGroup2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet10:= TGet():New(148,80,bSETGET(nGet10),oGroup2,50,010,"@E 9,999,999.9999",,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay11:= TSay():New(170,25,{||'Peso Líquido (KG):'},oGroup2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oGet11:= TGet():New(168,80,bSETGET(nGet11),oGroup2,50,010,"@E 9,999,999.9999",,,/*10*/,,,,.T.,/*15*/,,,,,/*20*/,,)

oSay12:= TSay():New(190,25,{||'Balança:'},oGroup2,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
oComboBL:= tComboBox():New(188,80,{|u|if(PCount()>0,cBalUTM:=u,cBalUTM)},aBlUtm,55,010,oGroup2,,{|| },,,,.T.,,,,,,,,,'cBalUTM')

//Botoes
@ 275,010 Button "Estornar"       Size 060,020  ACTION( U_EstorUTM(), IIF( VALTYPE(oDlg) == "O", oDlg:Refresh(),.T.))   PIXEL OF oDlg
@ 300,010 Button "Reimpressão"    Size 060,020  ACTION( U_UTMcet(), IIF( VALTYPE(oDlg) == "O", oDlg:Refresh(),.T.))   PIXEL OF oDlg
@ 287,142 Button "Pesar"          Size 060,020  ACTION( U_UTMpeso(), oGet11:SetFocus(), IIF( VALTYPE(oDlg) == "O", oDlg:Refresh(), .T. ))   PIXEL OF oDlg
@ 275,275 Button "Confirmar"      Size 060,020  ACTION( MsgRun( "Processando . . .","Aguarde . . .",{|| OKUTM(@cGet1,@nGet11) }),oGet11:SetFocus(),IIF(VALTYPE(oDlg) == "O", oDlg:Refresh(),.T.))   PIXEL OF oDlg
@ 300,275 Button "Sair"           Size 060,020  ACTION( oDlg:End())   PIXEL OF oDlg

oGet1:bValid	:= {|| !Empty(cGet1) .AND. (ExistCpo("SB1",cGet1))  }
oGet1:bvalid	:= {|| (cGet2  := Posicione("SB1",1,xFilial("SB1")+cGet1,"B1_DESC")), (cGet6  := Posicione("SB1",1,xFilial("SB1")+cGet1,"B1_GRUPO")) }
oGet3:bvalid	:= {|| (nGet9  := Posicione("ZB6",1,xFilial("ZB6")+cGet3,"ZB6_TARA")) }
oGet2:Refresh()
oGet6:Refresh()
oGet9:Refresh()
oGet2:bWhen     := {|| .F. }
oGet6:bWhen     := {|| .F. }
oGet7:bWhen     := {|| .F. }
oGet8:bWhen     := {|| .F. }
oGet9:bWhen     := {|| .F. }
oGet10:bWhen     := {|| .F. }
oGet11:bWhen    := {|| lDigPeso }

ACTIVATE MSDIALOG oDlg CENTERED
    
Return 


//*****************************************************************Funcões Auxiliares*********************************************************************************

/*/
	{Protheus.doc} Validacao para reimpressao de etiquetas só quando for o grupo UCET  
/*/
User Function UTMcet()
    IF SB1->B1_GRUPO == 'UCET'
        U_ETIQUTM( cGet5, .T. )
    ELSE
        MSGALERT( "O Produto selecionado não pertence ao grupo que pode ser feita reimpressão de etiquetas", "Atenção" )
    ENDIF
Return

/*/
	{Protheus.doc} Leitura do Peso informado na UTM  
/*/
User Function UTMpeso()

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

        IF !EMPTY(cGet3) .AND. !EMPTY(cGet4)

            DBSELECTAREA("ZZK")
            DBSETORDER(2)
            IF DBSEEK(FWxFilial('ZZK') + cGet6 + cGet3 + cGet4 + "D")
                IF MSGYESNO( "Já existe ticket dessa placa e caçamba com status disponível, deseja alterar o peso ?", "Alterar peso caçamba" )

                    RecLock("ZZK", .F.)
                    
                    ZZK->ZZK_PBRUTO := nGet8
                    ZZK->ZZK_PCCB := nGet10
                    ZZK->ZZK_PVEIC := nGet9
                    ZZK->ZZK_PPROD := nGet11
                    ZZK->ZZK_STATUS := "D"
                    ZZK->ZZK_IDOALT := cGetOPER
                    ZZK->ZZK_DTALT := Date()
                    ZZK->ZZK_HRALT := Time()
                    ZZK->(MsUnlock())

                    //Limpo todos os campos para próxima operação
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
            ENDIF
            cMSGRJ := 'Será gerado ticket da caçamba'
        ELSE
            oSayMSG:Refresh()
        ENDIF

    Elseif SB1->B1_GRUPO == 'UVEI' //Se estiver pesando o veiculo
        IF !EMPTY(cGet3)

            IF EMPTY( cGet4 )
                cMSGRJ := 'Será gerado ticket de veículo'
            ELSE
                cMSGRJ := 'Será gerado ticket de veículo + caçamba'
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
                IF MSGYESNO("O veículo é próprio, deseja atualizar o peso no cadastro de veículos?")
                    RecLock("ZB6", .F.)
                    ZB6->ZB6_TARA := nGet8
                    ZB6->(MsUnlock())
                    nGet9 := nGet8
                    oGet9:Refresh()
                    nGet11 := nGet8 - nGet9 - nGet10
                    oGet11:Refresh()
                ENDIF
            ENDIF

                DBSELECTAREA("ZZK")
                DBSETORDER(2)
                IF DBSEEK(FWxFilial('ZZK') + cGet6 + cGet3 + cGet4 + "D")
                    IF MSGYESNO( "Já existe ticket desse veiculo com status disponível, deseja alterar o peso ?", "Alterar peso veiculo" )

                        RecLock("ZZK", .F.)
                        
                        ZZK->ZZK_PBRUTO := nGet8
                        ZZK->ZZK_PCCB := nGet10
                        ZZK->ZZK_PVEIC := nGet9
                        ZZK->ZZK_PPROD := nGet11
                        ZZK->ZZK_STATUS := "D"
                        ZZK->ZZK_IDOALT := cGetOPER
                        ZZK->ZZK_DTALT := Date()
                        ZZK->ZZK_HRALT := Time()
                        ZZK->(MsUnlock())

                        //Limpo todos os campos para próxima operação
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

                        cMSGRJ := ""

                    ENDIF
                ENDIF
            oSayMSG:= TSay():New(230,25,{||cMSGRJ},oGroup3,,oFont2,,,,.T.,CLR_BLACK,CLR_WHITE,200,20)
        ELSE
            MSGALERT( "Placa do veículo não pode ser vazio", "Atenção" )
        ENDIF

    Elseif SB1->B1_GRUPO == 'UREJ' //Se estiver pesando o Rejeito
        
        IF !EMPTY(cGet3)
            cMSGRJ := 'Será gerado a saída do rejeito: '+ cGet2
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
		ELSE
            MSGALERT( "Placa do veículo é obrigatório", "Atenção" )
        ENDIF
	Else //Se estiver pesando reciclado 

        cMSGRJ := 'Será gerado a entrada do reciclado: '+ cGet2
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
    MSGALERT( "O campo produto não pode ser vazio", "Atenção" )
    oGet1:SetFocus()
ENDIF
Return()



/*/
	{Protheus.doc} OKUTM() - Geracao da Ordem de Producao e Apontamento da OP - UTM  
/*/

Static Function OKUTM(cGet1,nGet11)
    
	Local lRet 		:= .F.
	Local aMATA650 	:= {} //-Array com os campos Mata650 - Abertura de OP
	Local aMATA250	:= {} //-Array com os campos Mata250 - Apontamento de OP
	Local nOpc 		:= 3
	Local cCodOp	:= ""
	//incluida linha abaixo [Mauro Nagata Orizon 20221006]
	Local aArea		:= GetArea()
	//Incluido Linha abaixo - Rodrigo Moraes | Compila | 29/07/2022
	Local aAreaSD3	:= SD3->(GetArea())
	/*
   Local cEmpUTM   := SUPERGETMV("HZ_EMPUTM"   , .F., "01")       	//EMPRESA UTM      
   Local cFilUTM   := SUPERGETMV("HZ_FILUTM"   , .F., "66510660") 	//FILIAL UTM
	*/
	//substituido bloco acima pelo abaixo [Mauro Nagata, Orizon, 20220721]
    Local cFilUTM   := SUPERGETMV("HZ_FILUTM"   , .F., "") 	//FILIAL UTM
	//fim bloco [Mauro Nagata, Orizon, 20220721]
	Local cArmUTM   := SUPERGETMV("HZ_ARMUTM"   , .F., "01")       	//Local de Estoque UTM
    Local cVeicIN
	Local cMPUTM     := SUPERGETMV("HZ_PROUTM"   , .F., 'JG0052')     //CODIGO DE PRODUTO MP
	Private lmsErroAuto := .F.

    //Se for Veiculo ou cacamba preciso apenas cadastrar o ticket de pesagem e nao posso criar OP e fazer apontamentos.
    IF SB1->B1_GRUPO == 'UVEI' .OR. SB1->B1_GRUPO == 'UCCB'

        DBSELECTAREA("ZZK")
        DBSETORDER(2)
        IF DBSEEK(FWxFilial('ZZK') + cGet6 + cGet3 + cGet4 + "D") .AND. nGet8 = 0
            IF MSGYESNO( "Já existe ticket desse veiculo/caçamba com status disponível, deseja EXCLUIR o ticket?", "Excluir Ticket" )
                RecLock("ZZK", .F.)    

                ZZK->ZZK_STATUS := "C"
                ZZK->ZZK_IDOCAN := cGetOPER
                ZZK->(MsUnlock())

                //Limpo todos os campos para próxima operação
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
            //Limpo todos os campos para próxima operação
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
        //Se for reciclado ou rejeito, sigo com a rotina que já exixstia e no final faco o recklock na tabela de tickets UTM 
        cCodOp := GetNumSc2()
        
        dDataApt := IIF(MSDATE() == dDatabase,ddatabase,MSDATE())

        aMATA650 :=   {{'C2_FILIAL' 	,cFilUTM 	,NIL},;
                        {'C2_NUM' 		,cCodOp 	,NIL},; 
                        {'C2_ITEM' 		,"01" 		,NIL},; 
                        {'C2_SEQUEN' 	,"001" 		,NIL},;
                        {'C2_PRODUTO' 	,cGet1 	    ,NIL},;
                        {'C2_LOCAL' 	,cArmUTM 	,NIL},;
                        {'C2_QUANT' 	,nGet11  	,NIL},;
                        {'C2_DATPRI' 	,dDataApt 	,NIL},;
                        {'C2_DATPRF' 	,dDataApt 	,NIL},;
                        {"C2_TPOP"     ,"F"         ,NIL},;
                        {"C2_REVISAO"  ,"001"       ,NIL},;
                        {'C2_EMISSAO' 	,dDataApt 	,NIL},;
                        {'AUTEXPLODE' 	,"S" 		,NIL}}
            
        msExecAuto({|x,Y| Mata650(x,Y)}, aMata650, nOpc) // Geracao da Ordem de Producao
        
        If !lMsErroAuto
            ConOut("Abertura da OP - "+cCodOp+" Realizado com sucesso ")
            //Incluido Linha abaixo - Rodrigo Moraes | Compila | 29/07/2022
            cTimeUTM := Time()

            aMATA250 := { ;
                            {"D3_FILIAL"	,cFilUTM 		,NIL},;
                            {"D3_OP" 		,cCodOp+"01001" ,NIL},;
                            {"D3_COD" 		,cGet1 		,NIL},;
                            {"D3_QUANT" 	,nGet11 		,NIL},; 
                            {"D3_TM" 		,"002" 			,NIL},;
                            {"D3_PARCTOT"	,"T" 			,NIL},;
                            {"D3_PERDA"  	, 0            	,NIL},;      
                            {"D3_EMISSAO"	,dDataApt		,NIL},;
                            {"D3_HORAUTM"	,cTimeUTM      	,NIL},;
                            {"ATUEMP"    	,"T"           	, NIL}; 
                        }

            ConOut("Inicio Apontamento OP :- " + cCodOp+"  " + Time())

            MSExecAuto({|x, y| mata250(x, y)}, aMATA250, nOpc ) // Apontamento da OP

            If lMsErroAuto
                CONOUT("Erro no Apontemento da OP - " + cCodOp + " ")
                mostraerro()
                lRet := .F.
            Else
                CONOUT("Apontamento OP - " + cCodOp + " Realizado com sucesso")
                //MsgInfo("Apontamento OP - "+cCodOp+" Realizado com sucesso")

                If SB1->B1_GRUPO == "USET" .OR. SB1->B1_GRUPO == "UREJ"
                    MSGINFO( "Não será gerada etiqueta para este tipo de produto", "Grupo sem etiqueta" )
                Else
                    U_ETIQUTM(cCodOp) 		//Impressao da etiqueta -  Produtos do grupo UREJ, UVEI ou UCCB nao gera etiqueta
                EndIf

                //Incluido bloco abaixo - Rodrigo Moraes | Compila | 29/07/2022
                DbSelectArea("SD3")
                DbSetOrder(1)
                //If SD3->( Dbseek( xFilial("SD3") + cCodOp + "01001   " + cMPUTM ) ) 	// Posicionamento esta funcionando apenas para estruturas
                                                                                        // com apenas 1 componente, caso a estrutura receba mais 
                                                                                        // compenentes a rotina deverá ser revisada

                If DbSeek( xFilial("SD3") + cCodOp + "01001   " + cMPUTM ) 

                    RecLock( "SD3", .F. )
                        SD3->D3_HORAUTM := cTimeUTM
                    MsUnlock()
                EndIf
                //ResArea(aAreaSD3)
                //substituida linha acima pela abaixo [Mauro Nagata Orizon 20221006]
                RestArea(aAreaSD3)
                //Fim bloco abaixo - Rodrigo Moraes | Compila | 29/07/2022  

                lRet := .T.

            EndIf
        Else
            ConOut("Erro! A  OP - "+cCodOp+" nao foi aberta com sucesso")
            MostraErro()
        EndIf
        //incluida linha abaixo [Mauro Nagata Orizon 20221006]
        RestArea( aArea )

        cVeicIN := Posicione('ZB6', 1, FWxFilial('ZB6') + cGet3, 'ZB6_VEIIN')

        //Faço o recklock do ticket também
        RecLock("ZZK", .T.)
        ZZK->ZZK_FILIAL := FWxFilial('ZZK')
        ZZK->ZZK_IDTKT := cNumTkt
        ZZK->ZZK_IDPROC := "E"
        ZZK->ZZK_IDOPER := IIF( cGet6 == 'UREJ', "S", "E" )  
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
        ZZK->ZZK_STATUS := "F"
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
        //Limpo todos os campos para próxima operação
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

Return( lRet, nGet11, cGet1 )
//fim bloco [Mauro Nagata, Orizon, 20220720]



/*/
	{Protheus.doc} EstorUTM() - Estorno de um apontamento feito no UTM
    para efeito de validacao o get da OP nao pode estar vazio e nao se pode estornar veiculo nem cacamba
/*/

User Function EstorUTM()
	Local aArea := FWGetArea()
	
	IF EMPTY(cGet1)
		MSGALERT( "O produto não pode estar vazio", "Atencao" )
	ELSEIF SB1->B1_GRUPO == "UVEI"
		MSGALERT( "Não se pode estornar um veículo", "Atencao" )
	ELSEIF SB1->B1_GRUPO == "UCCB"
		MSGALERT( "Nao se pode estornar uma caçamba", "Atencao" )
	ELSE
		//Chama a tela
		fMontaTela()
	ENDIF

	FWRestArea(aArea)
Return

/*/{Protheus.doc} fMontaTela
Monta a tela com a marcacao de dados
/*/

Static Function fMontaTela()
    Local aArea         := GetArea()
    Local aCampos := {}
    Local oTempTable := Nil
    Local aColunas := {}
    Local cFontPad    := 'Tahoma'
    Local oFontGrid   := TFont():New(cFontPad,,-14)
    //Janela e componentes
    Private oDlgMark
    Private oPanGrid
    Private oMarkBrowse
    Private cAliasTmp := GetNextAlias()
    Private aRotina   := MenuDef()
    //Tamanho da janela
    Private aTamanho := MsAdvSize()
    Private nJanLarg := aTamanho[5]
    Private nJanAltu := aTamanho[6]
     
    //Adiciona as colunas que serao criadas na temporaria
    aAdd(aCampos, { 'OK', 'C', 2, 0}) //Flag para marcacao
    aAdd(aCampos, { 'C2_PRODUTO', 'C', 12, 0}) //Produto
    aAdd(aCampos, { 'C2_NUM', 'C', 6, 0}) //Numero OP
    aAdd(aCampos, { 'C2_EMISSAO', 'D', 8, 0}) //Data
	aAdd(aCampos, { 'C2_QUANT', 'N', 14, 0}) //Quant

    //Cria a tabela temporaria
    oTempTable:= FWTemporaryTable():New(cAliasTmp)
    oTempTable:SetFields( aCampos )
    oTempTable:Create()  

    //Popula a tabela temporaria
    Processa({|| fPopula()}, 'Processando...')

    //Adiciona as colunas que serao exibidas no FWMarkBrowse
    aColunas := fCriaCols()
     
    //Criando a janela
    DEFINE MSDIALOG oDlgMark TITLE 'Estornar OP' FROM 000, 000  TO nJanAltu, nJanLarg COLORS 0, 16777215 PIXEL
        //Dados
        oPanGrid := tPanel():New(001, 001, '', oDlgMark, , , , RGB(000,000,000), RGB(254,254,254), (nJanLarg/2)-1,     (nJanAltu/2 - 1))
        oMarkBrowse := FWMarkBrowse():New()
        oMarkBrowse:SetAlias(cAliasTmp)                
        oMarkBrowse:SetDescription('')
        oMarkBrowse:DisableFilter()
        oMarkBrowse:DisableConfig()
        oMarkBrowse:DisableSeek()
        oMarkBrowse:DisableSaveConfig()
        oMarkBrowse:SetFontBrowse(oFontGrid)
        oMarkBrowse:SetFieldMark('OK')
        oMarkBrowse:SetTemporary(.T.)
        oMarkBrowse:SetColumns(aColunas)
        //oMarkBrowse:AllMark() 
        oMarkBrowse:SetOwner(oPanGrid)
        oMarkBrowse:Activate()
    ACTIVATE MsDialog oDlgMark CENTERED
    
    //Deleta a temporaria e desativa a tela de marcacao
    oTempTable:Delete()
    oMarkBrowse:DeActivate()
    
    RestArea(aArea)
Return

/*/{Protheus.doc} MenuDef
Botões usados no Browse
/*/

Static Function MenuDef()
    Local aRotina := {{"Continuar", "U_btnOK()", 0,2}}
Return aRotina

/*/{Protheus.doc} fPopula
Executa a query SQL e popula essa informacao na tabela temporaria usada no browse
/*/

Static Function fPopula()
    Local cQryDados := ''
    Local nTotal := 0
    Local nAtual := 0
    Private OPdata := SuperGetMV("HZ_UTMOP", .F., .F.)

    //Monta a consulta
    cQryDados += "SELECT C2_PRODUTO, C2_NUM, C2_EMISSAO, C2_QUANT FROM SC2010 "		+ CRLF
    cQryDados += "WHERE C2_PRODUTO = '" + cGet1 + "' AND C2_EMISSAO >= '" + OPdata + "' AND D_E_L_E_T_ <> '*'"		+ CRLF
    cQryDados += "ORDER BY C2_EMISSAO DESC" + CRLF
    PLSQuery(cQryDados, 'QRYDADTMP')

    //Definindo o tamanho da régua
    DbSelectArea('QRYDADTMP')
    Count to nTotal
    ProcRegua(nTotal)
    QRYDADTMP->(DbGoTop())

    //Enquanto houver registros, adiciona na temporaria
    While ! QRYDADTMP->(EoF())
        nAtual++
        IncProc('Analisando registro ' + cValToChar(nAtual) + ' de ' + cValToChar(nTotal) + '...')

        RecLock(cAliasTmp, .T.)
            (cAliasTmp)->OK := Space(2)
            (cAliasTmp)->C2_PRODUTO := QRYDADTMP->C2_PRODUTO
            (cAliasTmp)->C2_NUM := QRYDADTMP->C2_NUM
            (cAliasTmp)->C2_EMISSAO := QRYDADTMP->C2_EMISSAO
			(cAliasTmp)->C2_QUANT := QRYDADTMP->C2_QUANT
        (cAliasTmp)->(MsUnlock())

        QRYDADTMP->(DbSkip())
    EndDo
    QRYDADTMP->(DbCloseArea())
    (cAliasTmp)->(DbGoTop())
Return

/*/{Protheus.doc} fCriaCols
Funcao que gera as colunas usadas no browse (similar ao antigo aHeader)
/*/

Static Function fCriaCols()
    Local nAtual       := 0 
    Local aColunas := {}
    Local aEstrut  := {}
    Local oColumn
    
    //Adicionando campos que serao mostrados na tela
    //[1] - Campo da Temporaria
    //[2] - Titulo
    //[3] - Tipo
    //[4] - Tamanho
    //[5] - Decimais
    //[6] - Máscara
    aAdd(aEstrut, { 'C2_PRODUTO', 'Produto', 'C', 12, 0, '@!'})
    aAdd(aEstrut, { 'C2_NUM', 'Numero OP', 'C', 6, 0, ''})
    aAdd(aEstrut, { 'C2_EMISSAO', 'Data', 'D', 8, 0, ''})
	aAdd(aEstrut, { 'C2_QUANT', 'Quantidade', 'N', 14, 0, ''})

    //Percorrendo todos os campos da estrutura
    For nAtual := 1 To Len(aEstrut)
        //Cria a coluna
        oColumn := FWBrwColumn():New()
        oColumn:SetData(&('{|| ' + cAliasTmp + '->' + aEstrut[nAtual][1] +'}'))
        oColumn:SetTitle(aEstrut[nAtual][2])
        oColumn:SetType(aEstrut[nAtual][3])
        oColumn:SetSize(aEstrut[nAtual][4])
        oColumn:SetDecimal(aEstrut[nAtual][5])
        oColumn:SetPicture(aEstrut[nAtual][6])

        //Adiciona a coluna
        aAdd(aColunas, oColumn)
    Next
Return aColunas

/*/{Protheus.doc} User Function btnOK
Funcao acionada pelo botao continuar da rotina
/*/

User Function btnOK()
    Processa({|| fProcessa()}, 'Processando...')
Return

/*/{Protheus.doc} fProcessa
Funcao que percorre os registros da tela
/*/

Static Function fProcessa()
    Local aArea     := FWGetArea()
    Local cMarca    := oMarkBrowse:Mark()
    Local nAtual    := 0
    Local nTotal    := 0
    Local nTotMarc := 0
    Local cDescOP
	Private cProdOP
	Private cNumOP
    Private nQTDOP

    //Define o tamanho da régua
    DbSelectArea(cAliasTmp)
    (cAliasTmp)->(DbGoTop())
    Count To nTotal
    ProcRegua(nTotal)
    
    //Percorrendo os registros
    (cAliasTmp)->(DbGoTop())
    While ! (cAliasTmp)->(EoF())
        nAtual++
    
        //Caso esteja marcado
        If oMarkBrowse:IsMark(cMarca)
            nTotMarc++
            cNumOP := (cAliasTmp)->C2_NUM
			cProdOP := (cAliasTmp)->C2_PRODUTO
			nQTDOP := (cAliasTmp)->C2_QUANT

            cDescOP := Posicione('SB1', 1, FWxFilial('SB1') + cProdOP, 'B1_DESC')

			IF MSGYESNO("Deseja estornar o lançamento da OP "+cNumOP+ " | Produto "+ALLTRIM(cDescOP)+ " | quantidade "+CVALTOCHAR(nQTDOP)+ " ?")
				U_REMAT250()
			ENDIF
        EndIf
         
        (cAliasTmp)->(DbSkip())
    EndDo

    FWRestArea(aArea)
Return


/*/{Protheus.doc} REMAT250
Funcao que faz o estorno da OP escolhida - Estorno da rotina Producao Simples
/*/

User Function REMAT250() 

Local aVetor    := {} 
Local nOpc      := 5 //-opcao de execussao da rotina, informado nos parametros quais as opcões possiveis 
Local cOp       := ALLTRIM(cNumOP) + "01001"+"   "
Local cCod      := cProdOP + SPACE(15-LEN(cProdOP))
Local cLocal    := "01" 
Local cChave    := "" 
lMsErroAuto     := .F.  

cChave:= xFilial("SD3") + cOp + cCod + cLocal 
SD3->(DbSetOrder(1)) 
    If SD3->(DbSeek(cChave))
            If SD3->D3_ESTORNO == " "  
            aVetor := { {"D3_FILIAL"        ,XFILIAL("SD3") ,NIL},;
                        {"D3_TM"            ,"002"          ,NIL},;
                        {"D3_OP"            ,cOp            ,NIL},;
                        {"D3_COD"           ,cCod           ,NIL},;
                        {"D3_QUANT"         ,nQTDOP         ,NIL},;
                        {"D3_LOCAL"         ,"01"           ,NIL},;
                        {"D3_EMISSAO"       ,dDatabase      ,NIL},;
                        {"ATUEMP"           , "T"           ,NIL}}   

                MSExecAuto({|x, y| mata250(x, y)},aVetor, nOpc )     

                If lMsErroAuto
                    Mostraerro()  
                Else   

                        //Crio um ticket para informar o estorno
                        RecLock("ZZK", .T.)
                        ZZK->ZZK_FILIAL := FWxFilial('ZZK')
                        ZZK->ZZK_IDTKT := cNumTkt
                        ZZK->ZZK_IDPROC := "E"
                        ZZK->ZZK_IDOPER := "S"  
                        ZZK->ZZK_CODPRO := cGet1
                        ZZK->ZZK_GPPROD := cGet6
                        ZZK->ZZK_STATUS := "E"
                        ZZK->ZZK_DTENT := Date()
                        ZZK->ZZK_HRENT := Time()
                        ZZK->ZZK_IDOEST := cGetOPER
                        
                        ZZK->(MsUnlock())

                        PUTMV("HZ_UTMTKT",cNumBkp)
                Endif  
            EndIf  
	ELSE
	MSGINFO("Não encontrado lançamento")
    EndIf 
    //Limpo todos os campos para próxima operação
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
	oDlgMark:END()
Return
