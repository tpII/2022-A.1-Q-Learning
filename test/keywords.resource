*** Settings ***
| Documentation    | Archivo de fuente, contiene variables y metodos
| Library          | DateTime
Library    String
Library    Collections

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


	
| Verificar Seteo De Parametros
|                    | [Arguments]    | ${qlearning}
|                    | ${learning_rate}=    | Set variable        | 0.4
|                    | ${discount}=         | Set variable        | 0.9
|                    | ${epsilon}=          | Set variable        | 0.9
|                    | ${learning_epsilon}= | Set variable        | 0.002
|                    | ${min_epsilon}=      | Set variable        | 0.15
|                    | ${max_movements}=    | Set variable        | 15
|                    | ${win_reward}=       | Set variable        | 4
|                    | ${loss_reward}=      | Set variable        | -4
|                    | ${dead_reward}=      | Set variable        | -4
|                    | ${loop_reward}=      | Set variable        | -4
|                    | Call Method    | ${qlearning}    | set_params      | ${learning_rate} | ${discount}   | ${epsilon}    | ${learning_epsilon}    | ${min_epsilon}    | ${max_movements}    | ${win_reward}    | ${loss_reward}    | ${dead_reward}    | ${loop_reward}
|                    | Should Be Equal As Numbers    | ${qlearning.LEARNING_RATE}    | ${learning_rate}
|                    | Should Be Equal As Numbers    | ${qlearning.DISCOUNT}         | ${discount}
|                    | Should Be Equal As Numbers    | ${qlearning.EPSILON}          | ${epsilon}
|                    | Should Be Equal As Numbers    | ${qlearning.LEARNING_EPSILON} | ${learning_epsilon}
|                    | Should Be Equal As Numbers    | ${qlearning.MIN_EPSILON}      | ${min_epsilon}
|                    | Should Be Equal As Numbers    | ${qlearning.MAX_MOVEMENTS}    | ${max_movements}
|                    | Should Be Equal As Numbers    | ${qlearning.WIN_REWARD}       | ${win_reward}
|                    | Should Be Equal As Numbers    | ${qlearning.LOSS_REWARD}      | ${loss_reward}
|                    | Should Be Equal As Numbers    | ${qlearning.DEAD_REWARD}      | ${dead_reward}
|                    | Should Be Equal As Numbers    | ${qlearning.LOOP_REWARD}      | ${loop_reward}


 Verificar Seteo De Parametros Por Default
|                    | [Arguments]    | ${qlearning}
|                    | ${learning_rate}=    | Set variable        | 0.4
|                    | ${discount}=         | Set variable        | 0.9
|                    | ${epsilon}=          | Set variable        | 0.9
|                    | ${learning_epsilon}= | Set variable        | 0.002
|                    | ${min_epsilon}=      | Set variable        | 0.15
|                    | ${max_movements}=    | Set variable        | 15
|                    | ${win_reward}=       | Set variable        | 4
|                    | ${loss_reward}=      | Set variable        | -4
|                    | ${dead_reward}=      | Set variable        | -4
|                    | ${loop_reward}=      | Set variable        | -4
|                    | Call Method        | ${qlearning}    | set_default_params      | 
|                    | Should Be Equal As Numbers    | ${qlearning.LEARNING_RATE}    | ${learning_rate}
|                    | Should Be Equal As Numbers    | ${qlearning.DISCOUNT}         | ${discount}
|                    | Should Be Equal As Numbers    | ${qlearning.EPSILON}          | ${epsilon}
|                    | Should Be Equal As Numbers    | ${qlearning.LEARNING_EPSILON} | ${learning_epsilon}
|                    | Should Be Equal As Numbers    | ${qlearning.MIN_EPSILON}      | ${min_epsilon}
|                    | Should Be Equal As Numbers    | ${qlearning.MAX_MOVEMENTS}    | ${max_movements}
|                    | Should Be Equal As Numbers    | ${qlearning.WIN_REWARD}       | ${win_reward}
|                    | Should Be Equal As Numbers    | ${qlearning.LOSS_REWARD}      | ${loss_reward}
|                    | Should Be Equal As Numbers    | ${qlearning.DEAD_REWARD}      | ${dead_reward}
|                    | Should Be Equal As Numbers    | ${qlearning.LOOP_REWARD}      | ${loop_reward}

 Verificar Obtencion De Parametros
|                    | [Arguments]    | ${qlearning}
|                    | ${learning_rate}=    | Set variable        | 0.4
|                    | ${discount}=         | Set variable        | 0.9
|                    | ${epsilon}=          | Set variable        | 0.9
|                    | ${learning_epsilon}= | Set variable        | 0.002
|                    | ${min_epsilon}=      | Set variable        | 0.15
|                    | ${max_movements}=    | Set variable        | 15
|                    | ${win_reward}=       | Set variable        | 4
|                    | ${loss_reward}=      | Set variable        | -4
|                    | ${dead_reward}=      | Set variable        | -4
|                    | ${loop_reward}=      | Set variable        | -4
|                    | Call Method    | ${qlearning}              | get_params      | 
|                    | Should Be Equal As Numbers    | ${qlearning.LEARNING_RATE}    | ${learning_rate}
|                    | Should Be Equal As Numbers    | ${qlearning.DISCOUNT}         | ${discount}
|                    | Should Be Equal As Numbers    | ${qlearning.EPSILON}          | ${epsilon}
|                    | Should Be Equal As Numbers    | ${qlearning.LEARNING_EPSILON} | ${learning_epsilon}
|                    | Should Be Equal As Numbers    | ${qlearning.MIN_EPSILON}      | ${min_epsilon}
|                    | Should Be Equal As Numbers    | ${qlearning.MAX_MOVEMENTS}    | ${max_movements}
|                    | Should Be Equal As Numbers    | ${qlearning.WIN_REWARD}       | ${win_reward}
|                    | Should Be Equal As Numbers    | ${qlearning.LOSS_REWARD}      | ${loss_reward}
|                    | Should Be Equal As Numbers    | ${qlearning.DEAD_REWARD}      | ${dead_reward}
|                    | Should Be Equal As Numbers    | ${qlearning.LOOP_REWARD}      | ${loop_reward}


| Verificar Inicializacion Variables
|                    | [Arguments]    | ${robot}
|                    | ${_raspi}=     | Set Variable    | ${True}
|                    | Variable Should Not Exist    | ${robot.adminES}    | La variable adminES existe
|                    | Should Be Equal    | ${robot.angulos[0]}    | ${0}
|                    | Should Be Equal    | ${robot.angulos[1]}    | ${40}
|                    | Should Be Equal    | ${robot.angulos[2]}    | ${75}
|                    | ${resultado}=      | Evaluate    | ${robot.encoders[0]} == ${0} or ${robot.encoders[0]} == ${1}
|                    | Should Be True     | ${resultado}
|                    | ${resultado}=      | Evaluate    | ${robot.encoders[1]} == ${0} or ${robot.encoders[1]} == ${1}
|                    | Should Be True     | ${resultado}
|                    | Should Be Equal    | ${robot.recompensa}    | ${0}
|                    | Should Not Be True | ${robot.lectura_bloqueada}
|                    | Should Be Equal    | ${robot.recompensa_avanzar}        | ${4}
|                    | Should Be Equal    | ${robot.recompensa_retroceder}     | ${-4}
|                    | Should Be Equal    | ${robot.recompensa_dead}           | ${-4}
|                    | ${resultado}=      | Evaluate    | len(${robot.state})
|                    | Should Be Equal    | ${resultado}    | ${2}
|                    | Should Be Equal    | ${robot.state[0]}      | ${0}
|                    | Should Be Equal    | ${robot.state[1]}      | ${2}

| Verificar Calculo De Avance
|                            | [Arguments]    | ${robot}
#|                            | ${vector}
#|                            | FOR | ${i} | IN RANGE | 2
#|                            |     Append To List    | ${vector}     | ${i}
#|                            | END
#|                            | Log To Console    | ${vector}
#|                            | Log To Console    | ${vector[0]}
|                            | ${robot.encoders}=     | Create List    | ${0}    | ${0}
|                            | ${encoders}=           | Create List    | ${1}    | ${0}
|                            | Log To Console   | ${robot.encoders}
|                            | ${resultado}=    | Call Method       | ${robot}    | calcular_avance    | ${encoders}
|                            | Log To Console    | ${resultado}
|                            | ${robot.encoders}=     | Create List    | ${0}    | ${1}
|                            | Log To Console   | ${robot.encoders}
|                            | ${resultado}=    | Call Method       | ${robot}    | calcular_avance    | ${robot.encoders}
|                            | Log To Console    | ${resultado}
|                            | ${robot.encoders}=     | Create List    | ${1}    | ${1}
|                            | Log To Console   | ${robot.encoders}
|                            | ${resultado}=    | Call Method       | ${robot}    | calcular_avance    | ${robot.encoders}
|                            | Log To Console    | ${resultado}
#|                            | ${resultado}=    | Call Method       | ${robot}    | calcular_avance    | ${robot.encoders}
|                            | Should Be Equal  | ${resultado}    | ${0}
