class_name CharacterBase
extends CharacterBody2D

@export var speed: float = 200.0
@export var health_component: HealthComponent

func _ready() -> void:
	if health_component:
		health_component.died.connect(die)

func die() -> void:
	queue_free() # O una animación de muerte
