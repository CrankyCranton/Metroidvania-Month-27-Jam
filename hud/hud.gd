extends CanvasLayer


#region Members
signal transformation_picked(transformation: String)

const ICONS := {
	"res://transformations/armored_car/armored_car.tscn": [preload("res://icon.svg")],
	"res://transformations/helicopter/helicopter.tscn": [preload("res://icon.svg")],
	"res://transformations/submarine/submarine.tscn": [preload("res://icon.svg")],
}

var button_map := {}

#region Onready
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var transformations_list: BoxContainer = $TransformationsList
#endregion
#endregion


#region Functions
#region Overrides
func _ready() -> void:
	init_health()
	for transformation: String in PlayerData.transformations.keys():
		_on_player_data_transformation_obtained(transformation)
	button_map[PlayerData.current_transformation].set_pressed_no_signal(true)
	PlayerData.transformation_obtained.connect(_on_player_data_transformation_obtained)
	PlayerData.transformed.connect(_on_player_data_transformed)


func _input(event: InputEvent) -> void:
	var input := int(event.as_text())
	if input >= 1 and input <= transformations_list.get_child_count():
		(transformations_list.get_child(input - 1) as Button).pressed.emit()
#endregion


func init_health() -> void:
	_on_player_data_max_health_changed(PlayerData.max_health)
	_on_player_data_health_changed(PlayerData.health)
	PlayerData.max_health_changed.connect(_on_player_data_max_health_changed)
	PlayerData.health_changed.connect(_on_player_data_health_changed)


#region Events
func _on_player_data_max_health_changed(max_health: int) -> void:
	if not is_node_ready():
		await ready
	health_bar.max_value = max_health


func _on_player_data_health_changed(health: int) -> void:
	if not is_node_ready():
		await ready
	health_bar.value = health


func _on_player_data_transformation_obtained(transformation: String) -> void:
	if button_map.has(transformation):
		var button: Button = button_map[transformation]
		var icon_upgrade_list: Array = ICONS[transformation]
		button.icon = icon_upgrade_list[icon_upgrade_list.find(button.icon) + 1]
		# If there is no icon for the upgrade level specified, then the game will crash.
	else:
		var button := preload("res://hud/transformation_button.tscn").instantiate()
		button.icon = ICONS[transformation].front()
		button_map[transformation] = button
		button.picked.connect(_on_transformation_button_picked)
		transformations_list.add_child(button)


func _on_player_data_transformed(transformation: String) -> void:
	for i in button_map.keys():
		button_map[i].set_pressed_no_signal(i == transformation)


func _on_transformation_button_picked(button: Button) -> void:
	for i in transformations_list.get_children():
		i.set_pressed_no_signal(i == button)

	transformation_picked.emit(button_map.find_key(button))
#endregion
#endregion
