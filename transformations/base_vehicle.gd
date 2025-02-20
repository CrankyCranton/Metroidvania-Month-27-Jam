class_name BaseVehicle extends RigidBody2D


#region Members
#region Export
@export var speed := 1000
@export var water_detector: Area2D
@export var water_damage := 1
#endregion

var level := 1

#region Onready
@onready var water_damage_timer: Timer = $WaterDamageTimer
#endregion
#endregion


#region Functions
#region Overrides
func _ready() -> void:
	connect_water_signals()


func _physics_process(_delta: float) -> void:
	apply_force(Input.get_vector(&"left", &"right", &"up", &"down") * speed)
#endregion


func connect_water_signals() -> void:
	if water_damage_timer:
		water_detector.area_entered.connect(_on_water_detector_area_entered)
		water_detector.area_exited.connect(_on_water_detector_area_exited)


#region Events
func _on_water_damage_timer_timeout() -> void:
	PlayerData.health -= water_damage


func _on_water_detector_area_entered(_area: Area2D) -> void:
	if water_damage_timer.is_stopped():
		water_damage_timer.start()


func _on_water_detector_area_exited(_area: Area2D) -> void:
	if water_detector.get_overlapping_areas().size() <= 0:
		water_damage_timer.stop()
#endregion
#endregion
