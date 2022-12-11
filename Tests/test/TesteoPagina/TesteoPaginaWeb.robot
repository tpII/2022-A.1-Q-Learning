*** Settings ***
Documentation     Simple example using SeleniumLibrary.
Library           SeleniumLibrary

*** Variables ***
${LOGIN URL}      http://localhost:5000
${BROWSER}        firefox

*** Test Cases ***
Testeo Inicio Pagina Web
    Open Browser    ${LOGIN URL}    ${BROWSER}
    Title Should Be    Crawler Server
    Element Should Be Enabled    id:Avanzar    
    Element Should Be Enabled    id:Entrenar
    Element Should Be Enabled    id:Reset

Testeo A La Pagina Web Boton Entrenar
    Click Button        id:Entrenar
    Element Should Be Visible         id:Finalizar
    Element Should Not Be Visible     id:Entrenar
    Click Button    id:Finalizar
    Element Should Not Be Visible     id:Finalizar
    Element Should Be Visible         id:Entrenar

Testeo A La Pagina Web Boton Avanzar
    Click Button        id:Avanzar
    Element Should Be Visible         id:Detener
    Element Should Not Be Visible     id:Avanzar
    Click Button    id:Detener
    Element Should Not Be Visible     id:Detener
    Element Should Be Visible         id:Avanzar

Testeo A La Pagina Web Boton Resetear
    Click Button        id:Reset
    Element Text Should Be  class:numero    0

Testeo A La Pagina Web Boton Hamburguesa Aplicar
    Title Should Be    Crawler Server
    Click Image    class:menu_button
    Click Element    class:input-number-increment    
    Click Element    name:aplicar
    Page Should Contain        Parámetros actualizados satisfactoriamente
     

Testeo A La Pagina Web Boton Hamburguesa Resetear
    Title Should Be    Crawler Server
    Click Element    name:reset
    Page Should Contain        Parámetros actualizados satisfactoriamente
    Click Image    id:cerrar_menu
    Close Browser 


