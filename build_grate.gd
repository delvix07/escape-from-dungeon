extends SceneTree

func _init() -> void:
	var root = StaticBody2D.new()
	root.name = "DungeonGrate"
	
	var script = load("res://scripts/environment/dungeon_grate.gd")
	if script:
		root.set_script(script)
	
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	sprite.texture = load("res://assets/Tiles/tile_0077.png")
	root.add_child(sprite)
	sprite.owner = root
	
	var col = CollisionShape2D.new()
	col.name = "CollisionShape2D"
	var shape = RectangleShape2D.new()
	shape.size = Vector2(16, 16)
	col.shape = shape
	root.add_child(col)
	col.owner = root
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(root)
	ResourceSaver.save(packed_scene, "res://scenes/levels/dungeon_grate.tscn")
	
	print("Grate scene created!")
	quit()
