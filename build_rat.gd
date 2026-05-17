extends SceneTree

func _init() -> void:
	var root = CharacterBody2D.new()
	root.name = "Rat"
	
	# Layer 3 = Enemy, Mask 1 = World
	root.collision_layer = 4
	root.collision_mask = 1
	
	var script = load("res://scripts/characters/rat.gd")
	if script:
		root.set_script(script)
		# Add character base properties
		root.set("speed", 50.0)
	
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	# Using an arbitrary tile for Rat for now
	sprite.texture = load("res://assets/Tiles/tile_0108.png") 
	root.add_child(sprite)
	sprite.owner = root
	
	var col = CollisionShape2D.new()
	col.name = "CollisionShape2D"
	var shape = CircleShape2D.new()
	shape.radius = 6.0
	col.shape = shape
	root.add_child(col)
	col.owner = root
	
	# Add Hurtbox Component
	var hurtbox_script = load("res://scripts/components/hurtbox_component.gd")
	if hurtbox_script:
		var hurtbox = Area2D.new()
		hurtbox.name = "HurtboxComponent"
		hurtbox.set_script(hurtbox_script)
		hurtbox.collision_layer = 8 # Enemy Hurtbox
		hurtbox.collision_mask = 0
		root.add_child(hurtbox)
		hurtbox.owner = root
		
		var hurtbox_col = CollisionShape2D.new()
		hurtbox_col.name = "CollisionShape2D"
		var hurtbox_shape = RectangleShape2D.new()
		hurtbox_shape.size = Vector2(16, 16)
		hurtbox_col.shape = hurtbox_shape
		hurtbox.add_child(hurtbox_col)
		hurtbox_col.owner = root
	
	# Add Health Component
	var health_script = load("res://scripts/components/health_component.gd")
	if health_script:
		var health = Node.new()
		health.name = "HealthComponent"
		health.set_script(health_script)
		health.set("max_health", 20.0)
		root.add_child(health)
		health.owner = root
		
		if hurtbox_script:
			var hurtbox = root.get_node("HurtboxComponent")
			hurtbox.set("health_component", health)
			root.set("health_component", health)
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(root)
	ResourceSaver.save(packed_scene, "res://scenes/characters/rat.tscn")
	
	print("Rat scene created!")
	quit()
