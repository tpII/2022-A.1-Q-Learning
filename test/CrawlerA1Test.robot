*** Settings ***
| Documentation      | Testeo al codigo de Crawler A1
| Library            | ../python_code/AdminES.py 
| Library            | ../python_code/QLearning.py
| Resource           | keywords.resource

*** Variables ***
| ${admines}=    | Get Library Instance    | AdminES

*** Test Cases ***
| AdminEs __init__    | [Documentation]    | Testeo al constructor de la clase AdminES
|                     | ${admines}=    | Get Library Instance    | AdminES
|                     | Verificar Pines    | ${admines}

| AdminES mover_servo | [Documentation]    | Testeo al metodo mover servo de la clase AdminES. Se testean distintos angulos de giro y pines y ademas el sleep de la funcion
|                     | ${admines}=    | Get Library Instance    | AdminES
|                     | Verificar Calculo Angulo    | ${admines}    | ${40}    | ${24}
|                     | Verificar Calculo Angulo    | ${admines}    | ${0}    | ${24}
|                     | Verificar Calculo Angulo    | ${admines}    | ${40}    | ${23}
|                     | Verificar Calculo Angulo    | ${admines}    | ${0}    | ${23}
|                     | Verificar Tiempo Sleep      | ${admines}    | ${40}    | ${24}

