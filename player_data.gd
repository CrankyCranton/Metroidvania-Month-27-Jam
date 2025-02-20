# NOTE: Make backwards compatability with older save files.
extends Node


#region Members
#region Signals
signal hurt
signal healed
signal health_changed(health: int)
signal max_health_changed(max_health: int)
signal died
#endregion

#region Constants
const INITIAL_HEALTH := 5
const PATH := "user://player_data.dat"
const PASSWORD := "If you are reading this line of code, stop reading. It's not worth your time."
#endregion

#region Variables
var transformations := {preload("res://transformations/armored_car/armored_car.tscn"): 1}
var current_transformation: PackedScene = transformations.keys().front()
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
#endregion
#endregion


#region Functions
func _ready() -> void:
	init_health(INITIAL_HEALTH)
	load_data()


#region Custom
@warning_ignore("shadowed_variable")
func init_health(health: int) -> void:
	max_health = health
	self.health = max_health


func save_data() -> void:
	var file := FileAccess.open_encrypted_with_pass(PATH, FileAccess.WRITE, PASSWORD)
	var error := FileAccess.get_open_error()
	if error != OK:
		OS.alert("Unable to save player data.\nError: " + error_string(error))
		return

	file.store_var(
		{
			"transformations": transformations, 
			"current_transformation": current_transformation,
			"spawn_point": spawn_point,
			"max_health": max_health,
			"health": health,
		}
	)


func load_data() -> void:
	var file := FileAccess.open_encrypted_with_pass(PATH, FileAccess.READ, PASSWORD)
	var error := FileAccess.get_open_error()
	if error != OK:
		if error == ERR_FILE_NOT_FOUND:
			# Only save when it would be natural;
			# not when the player first plays the game.
			pass#save_data()
		else:
			OS.alert("Unable to load player data.\nError: " + error_string(error))
		return

	var data: Dictionary = file.get_var()
	transformations = data.transformations
	current_transformation = data.current_transformation
	spawn_point = data.spawn_point
	max_health = data.max_health
	health = data.health
#endregion
#endregion
