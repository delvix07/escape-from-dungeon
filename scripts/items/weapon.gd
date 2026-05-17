extends Node2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox

func _ready() -> void:
	if hitbox:
		# Just to be safe, disable it at start
		hitbox.get_node("CollisionShape2D").disabled = true

func attack() -> void:
	if not anim_player.is_playing():
		anim_player.play("attack")
