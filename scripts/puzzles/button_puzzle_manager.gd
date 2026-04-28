class_name ButtonPuzzleManager
extends Node2D

@export var secuencia_correcta: Array[int] = [2,4,3,1]
@export var escena_premio: PackedScene
@export var sonido_error: AudioStreamPlayer
@export var posicion_premio: Node2D

var _indice_actual: int = 0

func _ready() -> void:
	# Nos conectamos recursivamente a todas las VentanaInteractiva hijas
	_conectar_ventanas(self)

func _conectar_ventanas(nodo: Node) -> void:
	for hijo in nodo.get_children():
		if hijo is VentanaInteractiva:
			hijo.ventana_presionada.connect(_on_ventana_presionada)
		elif hijo.get_child_count() > 0:
			# Llamada recursiva por si agrupas las ventanas dentro de otros nodos Node2D
			_conectar_ventanas(hijo)

func _on_ventana_presionada(id: int) -> void:
	# Si la secuencia está vacía o el puzzle ya terminó, no hacemos nada
	if secuencia_correcta.is_empty():
		return
		
	# Verificamos si el ID presionado coincide con el paso actual de la secuencia
	if id == secuencia_correcta[_indice_actual]:
		_indice_actual += 1
		
		# Si completamos toda la secuencia
		if _indice_actual >= secuencia_correcta.size():
			_completar_puzzle()
	else:
		_fallar_puzzle()

func _completar_puzzle() -> void:
	print("Puzzle de secuencia completado!")
	
	if escena_premio:
		var premio: Node = escena_premio.instantiate()
		
		# Determinamos dónde va a aparecer el premio
		var spawn_pos: Vector2 = global_position
		if posicion_premio:
			spawn_pos = posicion_premio.global_position
			
		if premio is Node2D:
			premio.global_position = spawn_pos
			
		# Añadimos el premio a la escena actual
		get_tree().current_scene.add_child(premio)
	
	# Desactivamos el puzzle vaciando la secuencia (o podrías usar un flag bool)
	secuencia_correcta.clear()
	_desconectar_ventanas(self)

func _fallar_puzzle() -> void:
	print("Secuencia incorrecta. Reiniciando...")
	
	if sonido_error:
		sonido_error.play()
		
	# Reseteamos el progreso del puzzle
	_indice_actual = 0

func _desconectar_ventanas(nodo: Node) -> void:
	# Útil para cuando el puzzle ya ha sido resuelto y no quieres
	# que se siga interactuando o disparando la lógica
	for hijo in nodo.get_children():
		if hijo is VentanaInteractiva:
			if hijo.ventana_presionada.is_connected(_on_ventana_presionada):
				hijo.ventana_presionada.disconnect(_on_ventana_presionada)
		elif hijo.get_child_count() > 0:
			_desconectar_ventanas(hijo)
