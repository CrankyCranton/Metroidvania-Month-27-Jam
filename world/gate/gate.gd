extends Area2D


@export_file var level: String
@export var other_gate: StringName


func _on_body_entered(_body: Node2D) -> void:
	var next_level: Node2D = load(level).instantiate()
	get_tree().root.add_child.call_deferred(next_level)
	
	PlayerData.level = level
	PlayerData.spawn_point = next_level.get_node(NodePath(other_gate + "/SpawnPoint")).global_position
	PlayerData.save_data()
	
	next_level.spawn()
	await next_level.ready
	get_tree().current_scene.queue_free()
	get_tree().current_scene = next_level
