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
|                    | Should Be Equal As Integers    | ${admines.pin_servo1}      | ${pin_servo1}    |
|                    | Should Be Equal As Integers    | ${admines.pin_servo2}      | ${pin_servo2}    |
|                    | Should Be Equal As Integers    | ${admines.pin_encoder1}    | ${pin_encoder1}    |
|                    | Should Be Equal As Integers    | ${admines.pin_encoder2}    | ${pin_encoder2}    |

| Verificar Calculo Angulo
## Se verifica la suma realizada en el calculo del angulo de movimiento del servoMotor
|                    | [Arguments]    | ${admines}    | ${angulo}    | ${pin}
|                    | ${ns}          | Create Dictionary    | x=${2000}    | y=${180}    | z=${500}
|                    | ${ancho}=      | Evaluate    | ${angulo}*x/y + z    | namespace=${ns}
|                    | Call Method    | ${admines}    | mover_servo    | ${pin}    | ${angulo}
|                    | Should Be Equal As Numbers    | ${admines.ancho}    | ${ancho}

| Verificar Tiempo Sleep
## Se verificar 
|                    | [Arguments]    | ${admines}    | ${angulo}    | ${pin}
|                    | ${tiempo_inicio}=    | Get Current Date
|                    | Call Method    | ${admines}    | mover_servo    | ${pin}    | ${angulo}
|                    | ${tiempo_final}=     | Get Current Date
|                    | ${tiempoMs}=      | Subtract Date From Date    | ${tiempo_final}    | ${tiempo_inicio}    | result_format=number
|                    | ${resultado}=     | Evaluate    | ${tiempoMs} >= 0.3
|                    | Should Be True    | ${resultado}


| Verificar Seteo Y Obtencion De Parametros
|                    | [Arguments]          | ${qlearning}
|                    | [Documentation] | Primero se setean los valores esperados, se setean los parametros por default, se verifica que coincidan, se obtienen los parametros y se vuelven a verificar
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
|                    | Call Method        | ${qlearning}          | set_default_params      | ## Se comprueba el set_default_params y el set_params que lo llama el mismo
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
|                    | Call Method        | ${qlearning}                  | get_params      | ##Se vuelven a comprar que los parametros sean correctos llamando a la funcion get_params
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



Verificar Iniciacion De Tabla Q 
##Se verifica la inicializacion de la Tabla q utilizada en el entrenamiento
|                    | [Arguments]    | ${qlearning}
|                    | Call Method    | ${qlearning}       | inicializar_q_table   | ## Se verifica que se cree la tabla correctamente al no pasarla como parametro
|                    | FOR | ${i} | IN RANGE |     3           
|                    |     FOR | ${j} | IN RANGE | 3
|                    |         FOR | ${k} | IN RANGE | 4 
|                    | Should Be Equal   | ${qlearning.q_table[${i}][${j}][${k}]} | ${0}    | ## Se verifica que el iniciar_q_table, crea una tabla con todos sus valores en 0
|                    | END |
|                    |     END |
|                    |         END |
|                    | Set Suite Variable | ${q_table} | ${qlearning.q_table} | ## Se copia la tabla en una variable local para tener una copia que modificar
|                    | ${q_table}= |  set variable | ${q_table++1} | ##Se modifica la tabla q_table y se vuelve a llamar al metodo para ver si la modifica realmente
# |                    | Log To Console | ${q_table} |
# |                    | Log To Console | ${qlearning.q_table} |
|                    | Call Method    | ${qlearning}       | inicializar_q_table  | ${q_table} | ## Se vuelve a llamar a la funcion para verificar el else de la misma y que modifique la tabla pasandosela como parametro
# |                    | Log To Console | ${q_table} |
|                    | FOR | ${i} | IN RANGE | 3            
|                    |     FOR | ${j} | IN RANGE | 3
|                    |         FOR | ${k} | IN RANGE | 4  
|                    | Should Be Equal     | ${qlearning.q_table[${i}][${j}][${k}]} | ${q_table[${i}][${j}][${k}]} | ## Se comprueba elemento a elemento que la tabla luego de ser pasada a la funcion se modifica y almacena correctamente
|                    | END |
|                    |     END |
|                    |         END |
                  
Verificar Iniciacion De Variables De Entrenamiento
## Se verifica el constructor de la clase Qlearning            
|                    | [Arguments]    | ${qlearning}
|                    | Should Not Be True    | ${qlearning.done} |                     ## Se verifica que la variable se asigne en false
|                    | Should Be Equal As Numbers   | ${qlearning.ACTIONS} | ${4} |     ## Se verifica que la variable se asigne en false
|                    | ${SIZE}= | Evaluate | (3, 3) | 
|                    | Should Be Equal  | ${qlearning.STATE_SIZE} | ${SIZE}	 |         ## Se verifica que el string que define el tamano sea correcto


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
