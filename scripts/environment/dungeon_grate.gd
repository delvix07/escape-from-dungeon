extends StaticBody2D

## Lista de Spawners que deben ser completados (todos sus enemigos destruidos) para abrir la reja
@export var spawner_triggers: Array[EnemySpawner]

var _enemies_expected: int = 0
var _enemies_defeated: int = 0
var _is_opening: bool = false

func _ready() -> void:
	for spawner in spawner_triggers:
		if spawner:
			_enemies_expected += 1
			spawner.spawned_node_freed.connect(_on_enemy_defeated)
			
	# Si configuramos el array vacio por error o sin spawners validos, no hacemos nada (queda cerrada)
	# O podríamos abrirla directamente, pero mejor dejarla cerrada para que el diseñador note el error.

func _on_enemy_defeated() -> void:
	_enemies_defeated += 1
	if _enemies_defeated >= _enemies_expected:
		open()

func open() -> void:
	if _is_opening:
		return
	_is_opening = true
	
	# Desactivamos la colisión para que el jugador pueda pasar inmediatamente
	$CollisionShape2D.set_deferred("disabled", true)
	
	# Reproducimos el sonido
	var audio = AudioStreamPlayer2D.new()
	audio.stream = preload("res://assets/sounds/gate_latch.wav")
	add_child(audio)
	audio.play()
	
	# Animamos el Sprite2D usando un Tween
	var tween = create_tween()
	var sprite = $Sprite2D
	
	# Movemos el sprite 16 píxeles hacia abajo y lo desvanecemos durante 1 segundo
	tween.tween_property(sprite, "position:y", sprite.position.y + 16, 1.0)
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, 1.0)
	
	# Al finalizar la animación, liberamos el nodo por completo
	tween.tween_callback(queue_free)
