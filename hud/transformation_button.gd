extends Button


signal picked(button: Button)


func _on_focus_entered() -> void:
	release_focus()


func _on_pressed() -> void:
	picked.emit(self)
