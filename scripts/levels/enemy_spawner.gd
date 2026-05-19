class_name EnemySpawner
extends Marker2D

## Se emite cuando el nodo que fue generado sale del árbol (muere/es destruido).
signal spawned_node_freed

## La escena del enemigo que va a aparecer (ej: rat.tscn)
@export var enemy_scene: PackedScene

## Tiempo de espera en segundos antes de aparecer el enemigo.
## NOTA: Este tiempo ignora la pausa del juego, por lo que si hay un popup abierto,
## el tiempo comenzará a contar recién cuando el popup se cierre.
@export var spawn_delay: float = 0.0

## Instancia el enemigo en la posición actual de este nodo.
func spawn() -> void:
	if spawn_delay > 0:
		# create_timer(time, process_always, process_in_physics, ignore_time_scale)
		# En process_always = false, el timer se detiene cuando el árbol de escena está pausado.
		await get_tree().create_timer(spawn_delay, false).timeout
		
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		enemy.global_position = global_position
		get_tree().current_scene.add_child(enemy)
		enemy.tree_exited.connect(func(): spawned_node_freed.emit())
