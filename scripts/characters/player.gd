class_name Player
extends Humanoid

func _ready() -> void:
	super._ready()
	y_sort_enabled = true

func _physics_process(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed
	move_and_slide()
