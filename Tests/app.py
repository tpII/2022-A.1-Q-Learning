from flask import Flask, render_template, request, redirect, url_for, g, send_from_directory
from flask_sqlalchemy import SQLAlchemy  
import jyserver.Flask as jsf
import numpy as np
import time
import random
import subprocess
  
from python_code.QLearning import QLearning
from python_code.Robot import _raspi
import python_code.constantes as const

# Si se está ejecutando en una Raspi, 
# determinar si es en producción (False - mediante Access Point)
# o desarrollo (True - mediante cable ethernet)
if _raspi: 
	_dev = False

# Creación de la aplicación Flask y establecimiento de la base de datos 
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///./crawler-database.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
db.init_app(app)

class QTable(db.Model):
	'''
		Modelo de la base de datos que establece una tabla de SQL
		donde estarán almacenadas las tablas Q entrenadas.
	'''
	__tablename__ = 'qtable'

	id = db.Column(db.Integer, primary_key=True)
	q_table = db.Column(db.PickleType, nullable=False)

	@staticmethod
	def get_by_id(id):
		return User.query.get(id)

with app.app_context():
	@jsf.use(app)
	class App:
		'''
			Clase que modela la aplicación Flask para su utilización con jyserver.
			Establece los metodos que pueden ser ejecutados a partir de eventos 
			producidos en la interfaz web como si de javascript se tratara. 
			De igual manera, permite la ejecución de las funciones de javascript 
			creadas, accediendo mediante self.js. 
			Aporta métodos a la vista para la ejecución de las funciones del 
			algoritmo Q-Learning, así como las del movimiento del robot.
		'''

		def __init__(self):
			'''
				Constructor de la clase App.
				Almacena una instancia de la clase QLearning y carga una tabla Q
				desde la base de datos para almacenarla como tabla inicial.
				Si la entrada no se encuentra creada o la base de datos está vacía se crea
				dicha entrada y/o se almacena una tabla Q vacía (con todos sus valores en 0).
			'''
			self.Q = QLearning(self)

			# Inicialización de las variables utilizadas para la administración de alertas en la vista
			self.post_params = False
			self.alertas = []
			self.check = 0

			# Cargado o inicialización de la base de datos
			if "qtable" in db.inspect(db.engine).get_table_names(): # Si la tabla existe en la base de datos
				database = QTable.query.all()

				if  not database == []: # Si existe y tiene elementos, toma el último
					self.entrada_db = database[-1]
					q_table = self.entrada_db.q_table
					self.Q.inicializar_q_table(q_table)	

				else: 					# Si existe pero se encuentra vacía, crea una entrada nueva
					self.Q.inicializar_q_table()

					# print(q_table)
					self.entrada_db = QTable(q_table=self.Q.q_table)
					db.session.add(self.entrada_db)
					db.session.commit()
			else:						# Si la tabla no existe en la base de datos
				db.create_all()
				self.Q.inicializar_q_table()

				self.entrada_db = QTable(q_table=self.Q.q_table)
				db.session.add(self.entrada_db)
				db.session.commit()


		def entrenar(self):
			'''
				Función que inicia el entrenamiento y guarda la tabla Q que ha 
				sido generada tras la ejecución del mismo, en la base de datos.
			'''
			self.Q.semaforo_done.acquire()
			self.Q.done = False
			self.Q.semaforo_done.release()

			q_table = self.Q.entrenar()
			
			self.entrada_db.query.update({"q_table" : q_table})
			db.session.commit()


		def avanzar(self):
			'''
				Función que inicia el movimiento del robot utilizando la tabla
				que se encuentra almacenada en la variable Q. Que puede ser una
				recientemente entrenada o la cargada inicialmente desde la BD. 
			'''
			self.Q.semaforo_done.acquire()
			self.Q.done = False
			self.Q.semaforo_done.release()

			self.Q.avanzar()


		def detener(self):
			'''
				Detener la ejecución del entrenamiento o del movimiento segun corresponda.
			'''
			self.Q.semaforo_done.acquire()
			self.Q.done=True
			self.Q.semaforo_done.release()
			

		def reset_table(self):
			'''
				Función que resetea toda la tabla Q a 0 en Q,
				la actualiza en la interfaz y en la base de datos.
			'''
			self.Q.inicializar_q_table()
			q_table = self.Q.q_table

			self.entrada_db.query.update({"q_table" : q_table})
			db.session.commit()

			self.js.update_table(list(q_table.flatten()), list(self.Q.robot.reset()))

		def ejecutar_tests(self):
			'''
				Funcion que ejecuta el script bash que corre los tests y genera
				los archivos html
			'''
			subprocess.run(["bash", "./test/ejecutarTests.bash"])
			subprocess.run(["coverage", "html", "--include", "*python_code*", "-d", "./templates/htmlcov/"])
			self.js.resultados_test()



@app.route('/', methods=['GET'])
def index():
	'''
		Metodo correspondiente a la ruta "/" de la web.
		Envía algunos parámetros a la vista como la tabla Q inicial,
		los parámetros de entrenamiento, las alertas y las constantes definidas.
	'''
	App.detener() # Si hubiese quedado en movimiento el Robot, el mismo es detenido

	# Valores a ser enviados a la vista
	q_table = App.Q.q_table
	config = App.Q.get_params()
	state = App.Q.robot.state

	# Parámetros enviados a la vista
	data={
		'titulo': 'Crawler Server',
		'q_table': list(q_table.flatten()),
		'config': config,
		'state': state,
		'check': App.check,
		'alertas': App.alertas,
		'minimos': const.minimos,
		'maximos': const.maximos,
		'steps': const.steps
	}

	# Si se han actualizado los parámetros de entrenamiento, limpia las variables de alerta
	if App.post_params:
		App.post_params = False
		App.check = 0
		App.alertas = []

	return App.render(render_template('index.html', data=data))

@app.route("/test",methods=["GET"])
def test():
	data={
		'titulo': "Crawler Tests"
	}

	return App.render(render_template('tests.html',data= data))

@app.route("/test/coverage",methods=["GET"])
def coverage():
	data={
		'titulo': "Crawler Tests"
	}

	return App.render(render_template('./htmlcov/index.html',data= data))

@app.route("/test/<path:path>")
def prueba(path):
	return send_from_directory('templates/htmlcov', path)


@app.route("/actualizar_parametros", methods=["POST"])
def actualizar_parametros():
	'''
		Se encarga de la gestión del formulario de actualización de los parámetros de entrenamiento.
		Actualiza los parámetros de entrenamiento utilizando los valores del formulario o seteando 
		los valores por defecto según se indique. 
		Realiza validaciones de valores máximos y mínimos de estos parámetros y agrega a la lista de 
		alertas los resultados de la actualización.
	'''
	App.post_params = True

	if 'aplicar' in request.form: # Si se ha clickeado en el botón aplicar

		# Se reciben los parámetros del modelo desde el formulario
		learning_rate = float(request.form['learning_rate'])
		discount_factor = float(request.form['discount_factor'])
		epsilon = float(request.form['epsilon'])
		learning_epsilon = float(request.form['learning_epsilon'])
		min_epsilon = float(request.form['min_epsilon'])
		max_movements = int(float(request.form['max_movements']))
		win_reward = int(float(request.form['win_reward']))
		loss_reward = int(float(request.form['loss_reward']))
		dead_reward = int(float(request.form['dead_reward']))
		loop_reward = int(float(request.form['loop_reward']))

		# Checkeo de los valores mínimos y máximos recibidos, crea alertas
		App.check = 1
		i = 0

		if not(learning_rate>=const.minimos[i] and learning_rate<=const.maximos[i]):
			App.alertas.append(f"Learning Rate fuera de los limites: ({const.minimos[i]}, {const.maximos[i]})")
			App.check = -1
		i+=1
		if not(discount_factor>=const.minimos[i] and discount_factor<=const.maximos[i]):
			App.alertas.append(f"Discount Factor fuera de los limites: ({const.minimos[i]}, {const.maximos[i]})")
			App.check = -1
		i+=1
		if not(epsilon>=const.minimos[i] and epsilon<=const.maximos[i]):
			App.alertas.append(f"Epsilon fuera de los limites: ({const.minimos[i]}, {const.maximos[i]})")
			App.check = -1
		i+=1
		if not(learning_epsilon>=const.minimos[i] and learning_epsilon<=const.maximos[i]):
			App.alertas.append(f"Learning Epsilon fuera de los limites: ({const.minimos[i]}, {const.maximos[i]})")
			App.check = -1
		i+=1
		if not(min_epsilon>=const.minimos[i] and min_epsilon<=const.maximos[i]):
			App.alertas.append(f"Min Epsilon fuera de los limites: ({const.minimos[i]}, {const.maximos[i]})")
			App.check = -1
		i+=1
		if not(max_movements>=const.minimos[i] and max_movements<=const.maximos[i]):
			App.alertas.append(f"Max Movements fuera de los limites: ({const.minimos[i]}, {const.maximos[i]})")
			App.check = -1
		i+=1
		if not(win_reward>=const.minimos[i] and win_reward<=const.maximos[i]):
			App.alertas.append(f"Win Reward fuera de los limites: ({const.minimos[i]}, {const.maximos[i]})")
			App.check = -1
		i+=1
		if not(loss_reward>=const.minimos[i] and loss_reward<=const.maximos[i]):
			App.alertas.append(f"Loss Reward fuera de los limites: ({const.minimos[i]}, {const.maximos[i]})")
			App.check = -1
		i+=1
		if not(dead_reward>=const.minimos[i] and dead_reward<=const.maximos[i]):
			App.alertas.append(f"Dead Reward fuera de los limites: ({const.minimos[i]}, {const.maximos[i]})")
			App.check = -1
		i+=1
		if not(loop_reward>=const.minimos[i] and loop_reward<=const.maximos[i]):
			App.alertas.append(f"Loop Reward fuera de los limites: ({const.minimos[i]}, {const.maximos[i]})")
			App.check = -1

		if App.check == 1: # Si no hay errores, actualiza los parámetros y envia la anecdota 
			App.Q.set_params(
				learning_rate,
				discount_factor,
				epsilon,
				learning_epsilon,
				min_epsilon,
				max_movements,
				win_reward,
				loss_reward,
				dead_reward,
				loop_reward
			)
			App.alertas.append("Parámetros actualizados satisfactoriamente")

	elif 'reset' in request.form: # Si se ha clickeado en el botón resetear
		App.Q.set_default_params()
		App.check = 1
		App.alertas.append("Parámetros actualizados satisfactoriamente")

	return redirect(url_for('index'))

def pagina_no_encontrada(error):
	'''
		Función que muestra el cartel de error 404
	'''
	data = {
		'titulo': 'Error 404!'
	}
	return render_template('404.html', data=data), 404


if __name__=='__main__':
	'''
		Programa principal

		Registra el manejador de error 404.
		Levanta el servidor de Flask en la dirección IP correspondiente.
	'''
	app.register_error_handler(404, pagina_no_encontrada)
	if _raspi:
		if _dev:
			print(" * Red local mediante ethernet")
			app.run(host='0.0.0.0', port=5000)     # Para red local mediante ethernet
		else:
			print(" * Access point")
			app.run(host='192.168.4.1', port=5000)  # Cuando está como access point
	else:
		print(" * Run PC - Debug")
		app.run(debug=True)  # Cuando está ejecutandose en PC
