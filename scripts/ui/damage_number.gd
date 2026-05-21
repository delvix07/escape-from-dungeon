extends Label

func _ready() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	
	# Move up
	tween.tween_property(self, "position:y", position.y - 30.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	# Fade out
	tween.tween_property(self, "modulate:a", 0.0, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	# Delete after finish
	tween.chain().tween_callback(queue_free)
