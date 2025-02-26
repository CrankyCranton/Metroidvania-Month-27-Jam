# NOTE: Make backwards compatability with older save files.
extends Node


#region Members
#region Signals
signal hurt
signal healed
signal health_changed(health: int)
signal max_health_changed(max_health: int)
signal died
signal transformation_obtained(transformation: String)
signal transformed(transformation: String)
#endregion

#region Constants
const INITIAL_HEALTH := 5
const PATH := "user://player_data.dat"
const PASSWORD := "If you are reading this line of code, stop reading. It's not worth your time."
#endregion

#region Variables
var transformations := {"res://transformations/armored_car/armored_car.tscn": 1}
var current_transformation: String = transformations.keys().front():
	set(value):
		current_transformation = value
		transformed.emit(current_transformation)
var level := "res://world/level_1.tscn"
var spawn_point := Vector2.INF
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
			died.emit()
var collected_buleprints := {}
#endregion
#endregion


#region Functions
func _ready() -> void:
	init_health(INITIAL_HEALTH)


#region Custom
func add_transformation(transformation: String) -> void:
	if transformations.has(transformation):
		transformations[transformation] += 1
	else:
		transformations[transformation] = 1
	transformation_obtained.emit(transformation)


@warning_ignore("shadowed_variable")
func init_health(health: int) -> void:
	max_health = health
	self.health = max_health


func save_data() -> void:
	var file := FileAccess.open_encrypted_with_pass(PATH, FileAccess.WRITE, PASSWORD)
	var error := FileAccess.get_open_error()
	if error != OK:
		var message := "Unable to save file {0}.\nError: {1}".format([PATH, error_string(error)])
		# Don't alert the player when unable to save.
		#OS.alert(message)
		push_error(message)
		return

	file.store_var(
		{
			"transformations": transformations,
			"current_transformation": current_transformation,
			"level": level,
			"spawn_point": spawn_point,
			"max_health": max_health,
			"health": health,
			"collected_buleprints": collected_buleprints,
		}
	)
	print("Save")


func load_data() -> Error:
	var file := FileAccess.open_encrypted_with_pass(PATH, FileAccess.READ, PASSWORD)
	var error := FileAccess.get_open_error()
	if error != OK:
		if error == ERR_FILE_NOT_FOUND:
			# Only save when it would be natural;
			# not when the player first plays the game.
			pass#save_data()
		else:
			var message := "Unable to load file {0}.\nError: {1}".format([PATH, error_string(error)])
			OS.alert(message)
			push_error(message)
		return error

	var data: Dictionary = file.get_var()
	transformations = data.transformations
	current_transformation = data.current_transformation
	level = data.level
	spawn_point = data.spawn_point
	max_health = data.max_health
	health = data.health
	collected_buleprints = data.collected_buleprints
	print("Load")
	return OK
#endregion
#endregion
