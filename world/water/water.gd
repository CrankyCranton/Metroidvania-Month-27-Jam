extends Area2D


@export var vel_multiplier := 0.6


#region Functions
func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: RigidBody2D) -> void:
	body.linear_velocity *= vel_multiplier
#endregion
