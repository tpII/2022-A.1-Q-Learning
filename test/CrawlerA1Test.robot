*** Settings ***
| Documentation      | Testeo al codigo de Crawler A1
| Variables          | ../app.py
| Library            | ../python_code/AdminES.py 
| Library            | ../python_code/QLearning.py     | ${app}
| Library            | ../python_code/Robot.py         | ${4}       | ${-4}   | ${-4}
| Resource           | keywords.resource

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

*** Test Cases ***
| QLearning set_params, set_default_params y get_params | [Documentation] | Testeo al set_params, set_default_params y get_params de la clase Qlearning
|                                                       | ${qlearning}=         | Get Library Instance        | QLearning
|                                                       | Verificar Seteo Y Obtencion De Parametros           | ${qlearning}      |
| QLearning __init__    | [Documentation] | Testeo al constructor de la clase Qlearning
|                       | ${qlearning}=         | Get Library Instance                    | QLearning
|                       | Verificar Iniciacion De Variables De Entrenamiento     | ${qlearning}  


*** Test Cases ***
| QLearning inicializar_q_table | [Documentation] | Testeo al inicializar_q_table con valores por defecto y con valores predeterminados
|                               | ${qlearning}=         | Get Library Instance                    | QLearning
|                               | Verificar Iniciacion De Tabla Q       | ${qlearning}

| Robot __init__                | [Documentation]    | Testeo al constructor de la clase Robot
|                               | ${robot}           | Get Library Instance                    | Robot
|                               | Verificar Inicializacion Variables    | ${robot}

| Robot calcular_avance         | [Documentation]    | Testeo a la funcion calcular_avance de la clase Robot 
|                               | ${robot}           | Get Library Instance    | Robot
|                               | Verificar Calculo De Avance     | ${robot}