extends RigidBody2D


@export var speed := 4000
@export var rotate_speed := 5000

@onready var body: RigidBody2D = %Body
@onready var pin: PinJoint2D = $PinJoint2D


func _physics_process(delta: float) -> void:
	apply_force(Input.get_vector(&"left", &"right", &"up", &"down") * speed)
	#apply_force(body.global_position.direction_to(global_position) * Input.get_axis(&"down", &"up") * speed)
	#body.apply_force(body.transform.x * Input.get_axis(&"left", &"right") * rotate_speed)
