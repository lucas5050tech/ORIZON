#INCLUDE "Protheus.ch"
#INCLUDE 'TBIConn.ch'
#INCLUDE "AP5Mail.ch"
#INCLUDE "RWMake.ch"   
#INCLUDE "TopConn.ch"  

/*/{Protheus.doc} CADOPER()
Função que monta a tela de cadastro de operadores.
@author Lucas Oliveira - 5050tech
@since 02/11/2023
/*/

User Function CADOPER()

    Local aArea    := GetArea()
    Local aAreaZZL  := ZZL->(GetArea())
    Local cDelOk   := ".T."
    Local cFunTOk  := ".T."
 
    //Chamando a tela de cadastros
    AxCadastro('ZZL', 'Cadastro de Operadores', cDelOk, cFunTOk)
 
    RestArea(aAreaZZL)
    RestArea(aArea)

RETURN
