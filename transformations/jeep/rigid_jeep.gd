extends RigidBody2D


@export var speed := 1000
@export var turn_speed := 2000

@onready var traction_area: Area2D = $TractionArea


func _physics_process(_delta: float) -> void:
	var input := Input.get_axis(&"left", &"right")
	if traction_area.get_overlapping_bodies().size() > 0:
		apply_force(transform.x * input * speed)
	elif get_contact_count() <= 0:
		apply_torque(input * turn_speed)
