class_name HitboxComponent
extends Area2D

@export var damage_amount: int = 10

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		area.take_damage(damage_amount)
