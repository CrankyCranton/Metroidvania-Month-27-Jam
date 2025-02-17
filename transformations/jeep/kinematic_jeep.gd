extends CharacterBody2D


const SPEED := 300.0
const JUMP_VELOCITY := -400.0
const ROTATION_SPEED := 10.0
const GRAVITY_SCALE := 0.75

var gravity := 0.0
var throttle := 0


func _physics_process(delta: float) -> void:
	if get_slide_collision_count() > 0:
		throttle = move_toward(throttle, Input.get_axis(&"left", &"right") * SPEED, SPEED * delta)
	gravity += get_gravity().y * GRAVITY_SCALE * delta
	velocity = Vector2(0.0, gravity) + (transform.x * throttle)

	move_and_slide()
	
	var normal := Vector2.ZERO
	for i in get_slide_collision_count():
		var current_normal := get_slide_collision(i).get_normal()
		if abs((-transform.y).angle_to(current_normal)) <= 10.0:
			normal += current_normal
	if is_on_floor():
		gravity = 0.0
	if normal != Vector2.ZERO:
		normal /= get_slide_collision_count()
		rotation = lerpf(rotation, normal.angle() + TAU / 4.0,
			delta * ROTATION_SPEED)
