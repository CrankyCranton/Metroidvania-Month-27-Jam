# NOTE: Make backwards compatability with older save files.
extends Node


#region Members
#region Constants
const PATH := "user://player_data.dat"
const PASSWORD := "If you're reading this line of code, stop reading. It's not worth your time."
#endregion

#region Variables
var transformations := {preload("res://transformations/armored_car/armored_car.tscn"): 1}
var current_transformation: PackedScene = transformations.keys().front()
var spawn_point := Vector2.INF
#endregion
#endregion


#region Functions
func _ready() -> void:
	load_data()


#region Custom
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
#endregion
#endregion
