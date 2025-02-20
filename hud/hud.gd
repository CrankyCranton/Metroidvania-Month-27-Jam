extends CanvasLayer


@onready var health_bar: TextureProgressBar = $HealthBar


#region Functions
func set_health(health: int) -> void:
	if not is_node_ready():
		await ready
	health_bar.value = health


func set_max_health(max_health: int) -> void:
	if not is_node_ready():
		await ready
	health_bar.max_value = max_health
#endregion
