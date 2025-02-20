extends Node2D


@onready var default_spawn_point: Vector2 = $ArmoredCar.global_position


#region Functions
func _init() -> void:
	PlayerData.died.connect(_on_player_data_died)


func spawn() -> void:
	$ArmoredCar.global_position = PlayerData.spawn_point if PlayerData.spawn_point != Vector2.INF \
			else default_spawn_point


func _on_player_data_died() -> void:
	PlayerData.health = PlayerData.max_health
	spawn()
#endregion
