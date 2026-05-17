extends SceneTree

func _init() -> void:
	var root = Node2D.new()
	root.name = "Sword"
	
	var script = load("res://scripts/items/weapon.gd")
	if script:
		root.set_script(script)
	
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	sprite.texture = load("res://assets/Tiles/tile_0104.png")
	# Offset the sprite so it rotates around its handle
	sprite.offset = Vector2(0, -10)
	root.add_child(sprite)
	sprite.owner = root
	
	var hitbox = Area2D.new()
	hitbox.name = "Hitbox"
	hitbox.collision_layer = 4 # Assuming layer 3 is Player attacks, but we will configure in code
	hitbox.collision_mask = 8 # Assuming layer 4 is Enemy hurtbox
	root.add_child(hitbox)
	hitbox.owner = root
	
	var col = CollisionShape2D.new()
	col.name = "CollisionShape2D"
	var shape = RectangleShape2D.new()
	shape.size = Vector2(8, 20)
	col.shape = shape
	col.position = Vector2(0, -10)
	# Disabled by default, enabled by animation
	col.disabled = true
	hitbox.add_child(col)
	col.owner = root
	
	var anim_player = AnimationPlayer.new()
	anim_player.name = "AnimationPlayer"
	root.add_child(anim_player)
	anim_player.owner = root
	
	var anim = Animation.new()
	anim.length = 0.3
	
	# Rotation track
	var rot_track = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(rot_track, NodePath("Sprite2D:rotation"))
	anim.track_insert_key(rot_track, 0.0, -PI/4)
	anim.track_insert_key(rot_track, 0.15, PI/2)
	anim.track_insert_key(rot_track, 0.3, 0.0)
	
	# Hitbox track
	var hit_track = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(hit_track, NodePath("Hitbox/CollisionShape2D:disabled"))
	anim.track_insert_key(hit_track, 0.0, false)
	anim.track_insert_key(hit_track, 0.2, true)
	
	var anim_lib = AnimationLibrary.new()
	anim_lib.add_animation("attack", anim)
	anim_player.add_animation_library("", anim_lib)
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(root)
	ResourceSaver.save(packed_scene, "res://scenes/items/sword.tscn")
	
	print("Sword scene created!")
	quit()
