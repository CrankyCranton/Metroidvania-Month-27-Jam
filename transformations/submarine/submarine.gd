extends BaseVehicle


func _physics_process(delta: float) -> void:
	if water_detector.get_overlapping_areas().size() > 0:
		gravity_scale = 0.0
		super(delta)
	else:
		gravity_scale = 1.0
