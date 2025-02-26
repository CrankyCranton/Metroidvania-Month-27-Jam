extends Node2D


#region Members
const PLAYER_NAME := "Player"

#region Onready
@onready var hud: CanvasLayer = $HUD
@onready var default_spawn_point: Vector2 = $DefaultSpawnPoint.global_position
#endregion
#endregion


#region Functions
#region Overrides
func _init() -> void:
	PlayerData.died.connect(_on_player_data_died)


func _ready() -> void:
	if PlayerData.collected_buleprints.has(scene_file_path):
		for path: String in PlayerData.collected_buleprints[scene_file_path]:
			get_node(path).queue_free()
	var player: BaseVehicle = load(PlayerData.current_transformation).instantiate()
	player.name = PLAYER_NAME
	add_child(player)
#endregion


#region Custom
func spawn() -> void:
	get_player().global_rotation = 0.0
	get_player().global_position = PlayerData.spawn_point if PlayerData.spawn_point != Vector2.INF \
			else default_spawn_point


func get_player() -> BaseVehicle:
	return get_node(PLAYER_NAME)
#endregion


#region Events
func _on_player_data_died() -> void:
	PlayerData.health = PlayerData.max_health
	spawn()


func _on_child_entered_tree(node: Node) -> void:
	if node.name == PLAYER_NAME:
		hud.transformation_picked.connect(node.change_vehicle)
#endregion
#endregion
