extends Node2D


#region Functions
func _ready() -> void:
	PlayerData.died.connect(_on_player_data_died)
	if PlayerData.spawn_point == Vector2.INF or PlayerData.level != scene_file_path:
		PlayerData.spawn_point = $ArmoredCar.global_position
	else:
		$ArmoredCar.global_position = PlayerData.spawn_point


func _on_player_data_died() -> void:
	PlayerData.health = PlayerData.max_health
	$ArmoredCar.global_position = PlayerData.spawn_point
#endregion
