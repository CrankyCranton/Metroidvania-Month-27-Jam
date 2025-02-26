extends Area2D


@export_file var transformation: String


func _on_body_entered(body: RigidBody2D) -> void:
	if body is not BaseVehicle:
		body = body.get_parent()
	PlayerData.add_transformation(transformation)
	PlayerData.spawn_point = global_position
	var current_scene := get_tree().current_scene
	PlayerData.collected_buleprints.get_or_add(current_scene.scene_file_path, []).append(
				current_scene.get_path_to(self))
	body.change_vehicle(transformation)
	PlayerData.save_data()
	queue_free()
