extends KinematicBody2D

signal hit
const normal_speed = 250
const dash_speed = normal_speed * 3
export var speed = normal_speed
export var stop_distance = 21
enum {NORMAL, DASH}
export var state = NORMAL
var direction
var screen_size

func _process(delta):
	_verify_state()
	_move_by_state()
	
func _verify_state():
	if Input.is_action_pressed("dash") && state != DASH:
		state = DASH
		$Dash.set_wait_time(0.4)
		$Dash.start()
		$DashSound.play()
	
func _look_at_mouse():
	look_at(get_global_mouse_position())
	rotation_degrees += 35
	#rotate(0.5)
	
func _move_by_state():
	match state:
		NORMAL:
			speed = normal_speed
			_look_at_mouse()
			_move_to_mouse()	
		DASH:
			speed = dash_speed
			_move()
	
func _move_to_mouse():
	if position.distance_to(get_global_mouse_position()) > stop_distance:
		direction = get_global_mouse_position() - position
		_move()
		
func _move():
	var normalized_direction = direction.normalized()
	var velocity = normalized_direction * speed
	move_and_slide(velocity)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
func start(pos):
	position = pos

func _on_Dash_timeout():
	state = NORMAL
	
func _ready():
	screen_size = get_viewport_rect().size
