*** Settings ***
| Documentation      | Testeo al codigo de Crawler A1
| Variables          | ../app.py
| Library            | ../python_code/AdminES.py 
| Library            | ../python_code/QLearning.py     | ${app}
| Library            | ../python_code/Robot.py         | ${4}       | ${-4}   | ${-4}
| Library            | ../app.py
| Test Timeout       | 10 seconds
| Resource           | keywords.resource

*** Test Cases ***
| AdminES __init__    | [Documentation]    | Testeo al constructor de la clase AdminES
|                     | ${admines}=    | Get Library Instance    | AdminES
|                     | Verificar Pines    | ${admines}

| AdminES mover_servo | [Documentation]    | Testeo al metodo mover servo de la clase AdminES. Se testean distintos angulos de giro y pines y ademas el sleep de la funcion
|                     | ${admines}=    | Get Library Instance    | AdminES
|                     | Verificar Calculo Angulo    | ${admines}    | ${40}    | ${24}
|                     | Verificar Calculo Angulo    | ${admines}    | ${0}    | ${24}
|                     | Verificar Calculo Angulo    | ${admines}    | ${40}    | ${23}
|                     | Verificar Calculo Angulo    | ${admines}    | ${0}    | ${23}
|                     | Verificar Tiempo Sleep      | ${admines}    | ${40}    | ${24}

| QLearning set_params, set_default_params y get_params | [Documentation] | Testeo al set_params, set_default_params y get_params de la clase Qlearning
|                                                       | ${qlearning}=         | Get Library Instance        | QLearning
|                                                       | Verificar Seteo Y Obtencion De Parametros           | ${qlearning}      |
| QLearning __init__    | [Documentation] | Testeo al constructor de la clase Qlearning
|                       | ${qlearning}=         | Get Library Instance                    | QLearning
|                       | Verificar Iniciacion De Variables De Entrenamiento     | ${qlearning}  

| QLearning inicializar_q_table | [Documentation] | Testeo al inicializar_q_table con valores por defecto y con valores predeterminados
|                               | ${qlearning}=         | Get Library Instance                    | QLearning
|                               | Verificar Iniciacion De Tabla Q       | ${qlearning}

| QLearning entrenar caja negra    | [Documentation]        | Testeo a la funcion entrenar de la clase Qlearning 
|                               | ${qlearning}               | Get Library Instance    | Qlearning
|                               | Verificar Entrenamiento    | ${qlearning}

| QLearning entrenar con spies   | [Documentation]            | Testeo a la funcion entrenar utilizando spias de la clase Qlearning
|                                     | ${qlearning}               | Get Library Instance    | Qlearning
|                                     | Verificar Entrenamiento Con Spies    | ${qlearning}
                    

| QLearning entrenar asignacion Tabla Q    | [Documentation]            | Testeo a la funcion entrenar verificando ecuacion Qlearning y asignacion en tabla Q utilizando spias de la clase Qlearning
|                                     | ${qlearning}               | Get Library Instance    | Qlearning
|                                     | Verificar Entrenamiento Con Spies    | ${qlearning}

| Robot __init__                | [Documentation]    | Testeo al constructor de la clase Robot
|                               | ${robot}           | Get Library Instance                    | Robot
|                               | Verificar Inicializacion Variables    | ${robot}

| Robot calcular_avance         | [Documentation]    | Testeo a la funcion calcular_avance de la clase Robot 
|                               | ${robot}           | Get Library Instance    | Robot
|                               | Verificar Calculo De Avance     | ${robot}

| Robot step                    | [Documentation]    | Testeo a la funcion step de la clase Robot 
|                               | ${robot}           | Get Library Instance    | Robot
|                               | Verificar Step     | ${robot}

| QLearning avanzar             | [Documentation]    | Testeo a la funcion avanzar de la clase Qlearning
|                               | ${qlearning}       | Get Library Instance    | QLearning
|                               | Verificar Avanzar  | ${qlearning}
