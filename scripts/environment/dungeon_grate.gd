extends StaticBody2D

## Lista de Spawners que deben ser completados (todos sus enemigos destruidos) para abrir la reja
@export var spawner_triggers: Array[EnemySpawner]

var _enemies_expected: int = 0
var _enemies_defeated: int = 0

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
	queue_free()
