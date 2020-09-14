extends Area2D

func _on_Diamond_body_entered(body):
	if body.name == "Player":
		hide()
		$CollisionPolygon2D.set_deferred("disabled", true)

func _on_Main_game_over():
	hide()
	$CollisionPolygon2D.set_deferred("disabled", true)
