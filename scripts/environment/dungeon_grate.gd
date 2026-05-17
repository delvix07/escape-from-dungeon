extends StaticBody2D

## NodePath to the enemy that triggers this grate to open (disappear)
@export var enemy_trigger: NodePath

func _ready() -> void:
	if not enemy_trigger.is_empty():
		var enemy = get_node(enemy_trigger)
		if enemy and enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died)

func _on_enemy_died() -> void:
	# Simply disappear when the target enemy dies
	queue_free()
