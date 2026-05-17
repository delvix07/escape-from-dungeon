extends CanvasLayer

@onready var tex_rect: TextureRect = $Control/VBoxContainer/Icon
@onready var lbl_name: Label = $Control/VBoxContainer/NameLabel
@onready var lbl_desc: Label = $Control/VBoxContainer/DescriptionLabel
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var current_item: ItemData

func _ready() -> void:
	# Hide initially
	hide()
	
	# Connect to the global signal
	GameEvents.show_item_popup.connect(show_popup)

func show_popup(item: ItemData) -> void:
	current_item = item
	
	if item.texture:
		tex_rect.texture = item.texture
	lbl_name.text = item.item_name
	lbl_desc.text = item.description
	
	if item.pickup_sound:
		audio_player.stream = item.pickup_sound
		audio_player.play()
	
	# Show UI and pause the game
	show()
	get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	# Only process if we are visible and paused
	if visible and get_tree().paused:
		if event.is_action_pressed("interactuar"):
			get_viewport().set_input_as_handled()
			_close_popup()

func _close_popup() -> void:
	hide()
	get_tree().paused = false
	
	# Notify the game that the item was confirmed
	if current_item:
		GameEvents.item_collected.emit(current_item)
		current_item = null
