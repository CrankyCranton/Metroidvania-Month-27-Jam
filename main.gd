extends Control


func _on_play_button_pressed() -> void:
	if PlayerData.load_data() in [ERR_FILE_NOT_FOUND, OK]:
		var level: Node2D = load(PlayerData.level).instantiate()
		get_tree().root.add_child.call_deferred(level)
		await level.ready
		get_tree().current_scene = level
		level.spawn()
		queue_free()
