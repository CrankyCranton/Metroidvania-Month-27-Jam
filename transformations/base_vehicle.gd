class_name BaseVehicle extends RigidBody2D


signal hurt
signal healed
signal health_changed(health: int)
signal max_health_changed(max_health: int)
signal died

@export var speed := 1000
@export var water_detector: Area2D
@export var water_damage := 1

var transformations := {}
var max_health: int:
	set(value):
		max_health = value
		max_health_changed.emit(max_health)
var health: int:
	set(value):
		if value < health:
			hurt.emit()
		elif value > health:
			healed.emit()
		health = value
		health_changed.emit(health)
		if health <= 0:
			die()
			died.emit()

@onready var water_damage_timer: Timer = $WaterDamageTimer


func _ready() -> void:
	init_health()
	connect_water_signals()


func _physics_process(_delta: float) -> void:
	apply_force(Input.get_vector(&"left", &"right", &"up", &"down") * speed)


func init_health() -> void:
	max_health = 10
	health = max_health


func connect_water_signals() -> void:
	if water_damage_timer:
		water_detector.area_entered.connect(_on_water_detector_area_entered)
		water_detector.area_exited.connect(_on_water_detector_area_exited)


func die() -> void:
	pass


func _on_water_damage_timer_timeout() -> void:
	health -= water_damage


func _on_water_detector_area_entered(_area: Area2D) -> void:
	if water_damage_timer.is_stopped():
		water_damage_timer.start()


func _on_water_detector_area_exited(_area: Area2D) -> void:
	if water_detector.get_overlapping_areas().size() <= 0:
		water_damage_timer.stop()
