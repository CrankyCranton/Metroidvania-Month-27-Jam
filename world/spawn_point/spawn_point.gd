extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	PlayerData.spawn_point = global_position
	PlayerData.save_data()
