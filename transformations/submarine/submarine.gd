extends BaseVehicle


func _ready() -> void:
	global_rotation = 0.0


func _physics_process(delta: float) -> void:
	angular_velocity = 0.0
	if water_detector.get_overlapping_areas().size() > 0:
		gravity_scale = 0.0
		super(delta)
	else:
		gravity_scale = 1.0
