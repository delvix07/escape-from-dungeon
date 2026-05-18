class_name Player
extends Humanoid

var inventory: InventoryManager

func _ready() -> void:
	super._ready()
	y_sort_enabled = true
	
	inventory = InventoryManager.new()
	add_child(inventory)
	
	# Connect to weapon equipped signal to update visuals
	inventory.weapon_equipped.connect(_on_weapon_equipped)

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	
	# Basic flip logic
	if direction.x > 0:
		$Visuals.scale.x = 1
	elif direction.x < 0:
		$Visuals.scale.x = -1
		
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
		current_weapon.position = Vector2(8, 0)
		$Visuals.add_child(current_weapon)
