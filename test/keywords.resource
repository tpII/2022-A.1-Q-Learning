*** Settings ***
| Documentation    | Archivo de fuente, contiene variables y metodos
| Library          | DateTime

*** Keywords ***
| Verificar Pines    
|                    | [Arguments]    | ${admines}
|                    | ${pin_servo1}=    | Set variable    | 23
|                    | ${pin_servo2}=    | Set variable    | 24
|                    | ${pin_encoder1}=    | Set variable    | 20
|                    | ${pin_encoder2}=    | Set variable    | 21
|                    | Should Be Equal As Integers    | ${admines.pin_servo1}    | ${pin_servo1}    |
|                    | Should Be Equal As Integers    | ${admines.pin_servo2}    | ${pin_servo2}    |
|                    | Should Be Equal As Integers    | ${admines.pin_encoder1}    | ${pin_encoder1}    |
|                    | Should Be Equal As Integers    | ${admines.pin_encoder2}    | ${pin_encoder2}    |

| Verificar Calculo Angulo
|                    | [Arguments]    | ${admines}    | ${angulo}    | ${pin}
|                    | ${ns}          | Create Dictionary    | x=${2000}    | y=${180}    | z=${500}
|                    | ${ancho}=      | Evaluate    | ${angulo}*x/y + z    | namespace=${ns}
|                    | Call Method    | ${admines}    | mover_servo    | ${pin}    | ${angulo}
|                    | Should Be Equal As Numbers    | ${admines.ancho}    | ${ancho}

| Verificar Tiempo Sleep
|                    | [Arguments]    | ${admines}    | ${angulo}    | ${pin}
|                    | ${tiempo_inicio}=    | Get Current Date
|                    | Call Method    | ${admines}    | mover_servo    | ${pin}    | ${angulo}
|                    | ${tiempo_final}=     | Get Current Date
|                    | ${tiempoMs}=      | Subtract Date From Date    | ${tiempo_final}    | ${tiempo_inicio}    | result_format=number
|                    | ${resultado}=     | Evaluate    | ${tiempoMs} >= 0.3
|                    | Should Be True    | ${resultado}
