extends RigidBody2D


@export var speed := 150

@onready var water_detector: Area2D = $WaterDetector


func _process(delta: float) -> void:
	if water_detector.get_overlapping_areas().size() > 0:
		apply_force(Input.get_vector(&"left", &"right", &"up", &"down") * speed)
