extends KinematicBody2D

signal die(body)
signal hit
export var speed = 50
export var player_position : Vector2

func _process(delta):
	_follow_the_player()
	
func _follow_the_player():
	look_at(player_position)
	rotation_degrees += 90
	var distance = position.distance_to(player_position)
	var direction = player_position - position
	var normalized_direction = direction.normalized()
	var velocity = normalized_direction * speed
	move_and_slide(velocity)
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
