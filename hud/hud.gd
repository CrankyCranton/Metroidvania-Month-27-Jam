extends CanvasLayer


@onready var health_bar: TextureProgressBar = $HealthBar


#region Functions
func _init() -> void:
	PlayerData.health_changed.connect(set_health)
	PlayerData.max_health_changed.connect(set_max_health)


#region Custom
func set_health(health: int) -> void:
	if not is_node_ready():
		await ready
	health_bar.value = health


func set_max_health(max_health: int) -> void:
	if not is_node_ready():
		await ready
	health_bar.max_value = max_health
#endregion
#endregion
