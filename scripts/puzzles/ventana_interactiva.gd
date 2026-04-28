class_name VentanaInteractiva
extends Area2D

signal ventana_presionada(id: int)

@export var ventana_id: int = 0
@export var prompt_sprite: Sprite2D
@export var audio_player: AudioStreamPlayer

var _jugador_cerca: bool = false

func _ready() -> void:
	if prompt_sprite:
		prompt_sprite.visible = false
	
	# Configuración de físicas: El Area2D solo detectará al Player (Capa 2)
	collision_layer = 0
	collision_mask = 2
	
	# Asegurarnos de conectar las señales del Area2D desde código
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _unhandled_input(event: InputEvent) -> void:
	if _jugador_cerca and event.is_action_pressed("interactuar"):
		# Consumir el evento para que no se propague a otros nodos
		get_viewport().set_input_as_handled()
		_interactuar()

func _interactuar() -> void:
	if audio_player:
		audio_player.play()
	
	ventana_presionada.emit(ventana_id)

func _on_body_entered(body: Node2D) -> void:
	print("player IN")
	# Podrías querer cambiar este if por un chequeo de collision_layer/mask
	# o buscando por grupo si no tienes un player con ese nombre de clase.
	if body.name.to_lower().contains("player") or body.is_in_group("player"):
		_jugador_cerca = true
		if prompt_sprite:
			prompt_sprite.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.name.to_lower().contains("player") or body.is_in_group("player"):
		_jugador_cerca = false
		if prompt_sprite:
			prompt_sprite.visible = false
