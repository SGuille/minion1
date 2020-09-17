extends KinematicBody2D

signal die(body)
signal hit
export var speed = 50
export var player_position : Vector2
export(float) var friction = 0.9

func _process(delta):
	_follow_the_player()
	
func _follow_the_player():
	look_at(player_position)
	rotation_degrees += 90
	var distance = position.distance_to(player_position)
	var direction = player_position - position
	var normalized_direction = direction.normalized()
	var velocity = normalized_direction * speed
	#velocity *= friction
	#if velocity.length() < 1:
	#	velocity = Vector2.ZERO
	move_and_slide(velocity)
	#move_and_slide(velocity, Vector2.ZERO, false, 4, PI/4, false)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if (collision.collider.name == "Player"):
			emit_signal("hit")
	
func _ready():
	$LiveTimer.start()

func _on_LiveTimer_timeout():
	emit_signal("die", self)
	queue_free()
	hide()
	set_deferred("disabled", true)
