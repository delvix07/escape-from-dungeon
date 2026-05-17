extends SceneTree

func _init() -> void:
	var canvas_layer = CanvasLayer.new()
	canvas_layer.name = "ItemPopupUI"
	canvas_layer.process_mode = Node.PROCESS_MODE_ALWAYS # Keep running while paused
	
	# Setting a script
	var script = load("res://scripts/items/item_popup_ui.gd")
	canvas_layer.set_script(script)
	
	var control = Control.new()
	control.name = "Control"
	control.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas_layer.add_child(control)
	control.owner = canvas_layer
	
	var bg = ColorRect.new()
	bg.name = "Background"
	bg.color = Color(0, 0, 0, 0.7)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	control.add_child(bg)
	bg.owner = canvas_layer
	
	var vbox = VBoxContainer.new()
	vbox.name = "VBoxContainer"
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	control.add_child(vbox)
	vbox.owner = canvas_layer
	
	var tex_rect = TextureRect.new()
	tex_rect.name = "Icon"
	tex_rect.custom_minimum_size = Vector2(64, 64)
	tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	vbox.add_child(tex_rect)
	tex_rect.owner = canvas_layer
	
	var lbl_name = Label.new()
	lbl_name.name = "NameLabel"
	lbl_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_name.text = "Item Name"
	vbox.add_child(lbl_name)
	lbl_name.owner = canvas_layer
	
	var lbl_desc = Label.new()
	lbl_desc.name = "DescriptionLabel"
	lbl_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_desc.text = "Description here..."
	vbox.add_child(lbl_desc)
	lbl_desc.owner = canvas_layer
	
	var lbl_hint = Label.new()
	lbl_hint.name = "HintLabel"
	lbl_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl_hint.text = "Press Action to continue"
	lbl_hint.modulate = Color(1, 1, 1, 0.5)
	vbox.add_child(lbl_hint)
	lbl_hint.owner = canvas_layer
	
	var audio = AudioStreamPlayer.new()
	audio.name = "AudioStreamPlayer"
	canvas_layer.add_child(audio)
	audio.owner = canvas_layer
	
	var packed_scene = PackedScene.new()
	packed_scene.pack(canvas_layer)
	ResourceSaver.save(packed_scene, "res://scenes/items/item_popup_ui.tscn")
	
	print("ItemPopupUI scene created successfully!")
	quit()
