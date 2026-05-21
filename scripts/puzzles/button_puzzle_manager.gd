class_name ButtonPuzzleManager
extends Node2D

@export var secuencia_correcta: Array[int] = [2,4,3,1]
@export var escena_premio: PackedScene
@export var contenido_premio: ItemData
@export var sonido_error: AudioStreamPlayer
@export var sonido_exito: AudioStreamPlayer
@export var posicion_premio: Node2D
@export var spawners_al_abrir: Array[EnemySpawner] = []

var _indice_actual: int = 0
var _secuencia_actual_valida: bool = true

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
	# Si la secuencia está vacía o el puzzle ya terminó (o estamos en el delay), no hacemos nada
	if secuencia_correcta.is_empty() or _indice_actual >= secuencia_correcta.size():
		return
		
	# Verificamos si el ID presionado coincide con el paso actual de la secuencia
	if id != secuencia_correcta[_indice_actual]:
		_secuencia_actual_valida = false
		
	_indice_actual += 1
	
	# Si completamos la cantidad de pasos de la secuencia
	if _indice_actual >= secuencia_correcta.size():
		await get_tree().create_timer(1.0).timeout
		if _secuencia_actual_valida:
			_completar_puzzle()
		else:
			_fallar_puzzle()

func _completar_puzzle() -> void:
	print("Puzzle de secuencia completado!")
	
	if sonido_exito:
		sonido_exito.play()
		
	if escena_premio:
		var premio: Node = escena_premio.instantiate()
		
		# Inyectamos el ítem configurado si el premio lo soporta
		if "content" in premio and contenido_premio != null:
			premio.content = contenido_premio
			
		# Si el premio puede ser abierto (ej: cofre), conectamos los spawners
		if premio.has_signal("chest_opened"):
			for spawner in spawners_al_abrir:
				if spawner:
					premio.chest_opened.connect(spawner.spawn)
		
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
	_secuencia_actual_valida = true
	_resetear_ventanas(self)

func _resetear_ventanas(nodo: Node) -> void:
	for hijo in nodo.get_children():
		if hijo is VentanaInteractiva:
			hijo.resetear()
		elif hijo.get_child_count() > 0:
			_resetear_ventanas(hijo)

func _desconectar_ventanas(nodo: Node) -> void:
	# Útil para cuando el puzzle ya ha sido resuelto y no quieres
	# que se siga interactuando o disparando la lógica
	for hijo in nodo.get_children():
		if hijo is VentanaInteractiva:
			hijo.desactivar_permanentemente()
			if hijo.ventana_presionada.is_connected(_on_ventana_presionada):
				hijo.ventana_presionada.disconnect(_on_ventana_presionada)
		elif hijo.get_child_count() > 0:
			_desconectar_ventanas(hijo)
