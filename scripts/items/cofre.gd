class_name CofreItem
extends Node2D

@export var sprite: Sprite2D
@export var area_interaccion: Area2D
@export var sonido_abrir: AudioStreamPlayer2D

var _abierto: bool = false
var _jugador_cerca: bool = false

# Cargamos las texturas directamente desde la ruta especificada
var tex_cerrado: Texture2D = preload("res://assets/Tiles/tile_0089.png")
var tex_abierto: Texture2D = preload("res://assets/Tiles/tile_0090.png")

func _ready() -> void:
	# Aseguramos que inicie cerrado
	if sprite:
		sprite.texture = tex_cerrado
		
	if area_interaccion:
		# Configuramos las físicas para que solo detecte al Player (Capa 2)
		area_interaccion.collision_layer = 0
		area_interaccion.collision_mask = 2
		
		# Conectamos las señales desde código
		area_interaccion.body_entered.connect(_on_body_entered)
		area_interaccion.body_exited.connect(_on_body_exited)

func _unhandled_input(event: InputEvent) -> void:
	# Solo permitimos abrir si el jugador está cerca, el cofre está cerrado 
	# y presiona el botón de acción (asumiendo que se llama "interactuar" o puedes cambiarlo al nombre de tu input)
	if _jugador_cerca and not _abierto and event.is_action_pressed("interactuar"):
		get_viewport().set_input_as_handled()
		abrir_cofre()

func abrir_cofre() -> void:
	_abierto = true
	if sprite:
		sprite.texture = tex_abierto
	
	if sonido_abrir:
		sonido_abrir.play()
		
	# Aquí puedes emitir una señal si quieres que el cofre suelte loot, por ejemplo:
	# loot_dropped.emit()
	print("¡Cofre abierto!")

func _on_body_entered(body: Node2D) -> void:
	# Validamos que el cuerpo sea el jugador
	if body.name.to_lower().contains("player") or body.is_in_group("player"):
		_jugador_cerca = true

func _on_body_exited(body: Node2D) -> void:
	if body.name.to_lower().contains("player") or body.is_in_group("player"):
		_jugador_cerca = false
