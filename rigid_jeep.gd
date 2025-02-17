extends RigidBody2D


const SPEED := 1000
const TURN_SPEED := 2000

@onready var traction_area: Area2D = $TractionArea


func _physics_process(delta: float) -> void:
	if traction_area.get_overlapping_bodies().size() > 0:
		apply_force(transform.x * Input.get_axis("ui_left", "ui_right") * SPEED)
	elif get_contact_count() <= 0:
		apply_torque(Input.get_axis("ui_right", "ui_left") * TURN_SPEED)
