extends BaseVehicle


#@export var rotate_speed := 5000

#@onready var body: RigidBody2D = %Body
#@onready var pin: PinJoint2D = $PinJoint2D



	#apply_force(body.global_position.direction_to(global_position) * Input.get_axis(&"down", &"up") * speed)
	#body.apply_force(body.transform.x * Input.get_axis(&"left", &"right") * rotate_speed)
