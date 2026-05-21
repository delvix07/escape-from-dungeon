class_name HurtboxComponent
extends Area2D

signal hit_received(amount: int, attack_source_position: Vector2, knockback_force: float)

@export var health_component: HealthComponent
@export var invulnerability_duration: float = 1.0

var is_invulnerable: bool = false
var invulnerability_timer: Timer

func _ready() -> void:
	invulnerability_timer = Timer.new()
	invulnerability_timer.one_shot = true
	invulnerability_timer.timeout.connect(_on_invulnerability_timeout)
	add_child(invulnerability_timer)

func take_damage(amount: int, attack_source_position: Vector2 = global_position, knockback_force: float = 0.0) -> void:
	if is_invulnerable:
		return
		
	if health_component:
		health_component.damage(amount)
		hit_received.emit(amount, attack_source_position, knockback_force)
		
		# Start invulnerability
		is_invulnerable = true
		invulnerability_timer.start(invulnerability_duration)

func _on_invulnerability_timeout() -> void:
	is_invulnerable = false
	
	# Check if still overlapping any hitboxes to re-apply damage
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		if area is HitboxComponent:
			# We call take_damage on ourselves using the hitbox's parameters
			take_damage(area.damage_amount, area.global_position, area.knockback_force)
			break
