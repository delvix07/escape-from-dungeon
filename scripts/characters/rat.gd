extends CharacterBase

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	super._ready()
	# Optional: you can add the player group if it doesn't exist
	
func _physics_process(_delta: float) -> void:
	if not player:
		# Try to find player if not found initially
		player = get_tree().get_first_node_in_group("player")
		return
		
	# Simple AI: Move towards player on X axis
	var dir = sign(player.global_position.x - global_position.x)
	velocity.x = dir * speed
	
	# Flip sprite based on direction
	if dir != 0:
		$Visuals.scale.x = -dir
		
	# Simple gravity if needed, but since it's a top-down Y-sort, maybe just X/Y movement
	var dir_y = sign(player.global_position.y - global_position.y)
	velocity.y = dir_y * speed
	
	move_and_slide()
