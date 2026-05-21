class_name Player
extends Humanoid

var inventory: InventoryManager

@export var walk_frequency: float = 15.0
@export var walk_amplitude: float = 12.0

const DAMAGE_NUMBER_SCENE = preload("res://scenes/ui/damage_number.tscn")
const PUNCH_SOUND = preload("res://assets/sounds/punch_hit.mp3")

var is_knocked_back: bool = false
var current_knockback: Vector2 = Vector2.ZERO
var hit_audio_player: AudioStreamPlayer

func _ready() -> void:
	super._ready()
	y_sort_enabled = true
	add_to_group("player")
	
	inventory = InventoryManager.new()
	add_child(inventory)
	
	# Connect to weapon equipped signal to update visuals
	inventory.weapon_equipped.connect(_on_weapon_equipped)
	
	# Setup damage feedback
	hit_audio_player = AudioStreamPlayer.new()
	hit_audio_player.stream = PUNCH_SOUND
	add_child(hit_audio_player)
	
	if has_node("Hurtbox"):
		$Hurtbox.hit_received.connect(_on_hurtbox_hit_received)

func _physics_process(_delta: float) -> void:
	if is_knocked_back:
		velocity = current_knockback
		current_knockback = current_knockback.lerp(Vector2.ZERO, 15.0 * _delta)
		if current_knockback.length() < 10.0:
			is_knocked_back = false
	else:
		var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		velocity = direction * speed
		
		# Basic flip logic
		if direction.x > 0:
			$Visuals.scale.x = 1
		elif direction.x < 0:
			$Visuals.scale.x = -1
		
	# Procedural walk animation
	if velocity.length() > 0:
		$Visuals/Sprite2D.rotation_degrees = sin(Time.get_ticks_msec() * 0.001 * walk_frequency) * walk_amplitude
	else:
		$Visuals/Sprite2D.rotation_degrees = lerp($Visuals/Sprite2D.rotation_degrees, 0.0, 15.0 * _delta)
		
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interactuar") and current_weapon != null:
		# Assume current_weapon is a scene instance with an attack() method
		if current_weapon.has_method("attack"):
			current_weapon.attack()

func _on_weapon_equipped(item: ItemData) -> void:
	if current_weapon:
		current_weapon.queue_free()
		
	# Instanciamos la escena asociada a este ItemData
	if item.item_scene:
		current_weapon = item.item_scene.instantiate()
		# Add slightly offset so it looks like it's in the hand
		current_weapon.position = Vector2(8, 4)
		$Visuals.add_child(current_weapon)

func _on_hurtbox_hit_received(amount: int, attack_source_position: Vector2, knockback_force: float) -> void:
	hit_audio_player.play()
	
	var tween = create_tween()
	$Visuals.modulate = Color(1, 0, 0, 1)
	tween.tween_property($Visuals, "modulate", Color(1, 1, 1, 1), 0.3)
	
	var knockback_dir = (global_position - attack_source_position).normalized()
	if knockback_dir == Vector2.ZERO:
		knockback_dir = Vector2.RIGHT.rotated(randf() * TAU)
		
	current_knockback = knockback_dir * knockback_force
	is_knocked_back = true
	
	var dmg_num = DAMAGE_NUMBER_SCENE.instantiate()
	dmg_num.text = str(amount)
	dmg_num.global_position = global_position + Vector2(-10, -20)
	get_tree().current_scene.add_child(dmg_num)
