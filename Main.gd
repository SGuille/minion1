extends Node2D

export (PackedScene) var Enemy
export (PackedScene) var Hole
export (PackedScene) var Diamond

var active_enemies = []
var max_enemies = 30
var holes = []
var holes_position = []
var score = 0
var max_diamond = 10
var diamond_shown = 0
var diamond_list = []

func _process(delta):
	for enemy in active_enemies:
		if (enemy != null):
			enemy.player_position = $Player.position

func _on_NewGame_pressed():
	$WelcomeHUD._hide()
	score = 0
	max_diamond = 10
	diamond_shown = 0
	$DiamondTimer.start()
	$GameOverHUD._hide()
	$Enemies.start()
	$GamerOverSound.stop()
	if (!$BackgroundSound.playing):
		$BackgroundSound.play()
	$Score.text = str(score)
	_show_player()
	_spawn_diamond()
	_show_holes()

func _show_enemy():
	randomize()
	var position = randi()%4
	var enemy = Enemy.instance()
	enemy.position = holes_position[position]
	enemy.connect("hit", self, "_on_Player_hit")
	enemy.connect("die", self, "_on_enemy_dead")
	enemy.speed = enemy.speed * $WelcomeHUD.dificulty
	add_child(enemy)
	active_enemies.append(enemy)

func _show_player():
	$Player.show()
	$Player.position = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)

func _on_Enemies_timeout():
	if (active_enemies.size() < max_enemies):
		_show_enemy()

func _on_Player_hit():
	$GamerOverSound.play()
	$BackgroundSound.stop()
	$GameOverHUD._show()
	_clean_holes_and_triangles()
	
func _clean_holes_and_triangles():
	for item in active_enemies:
		item.hide()
		item.set_deferred("disabled", true)
		item.queue_free()
	active_enemies = []
	for item in holes:
		item.hide()
		item.set_deferred("disabled", true)
		item.queue_free()
	holes = []
	for item in diamond_list:
		item.hide()
		item.set_deferred("disabled", true)
		item.queue_free()
	diamond_list = []
	holes_position = []
	$Player.hide()
	$DiamondTimer.stop()
	$Enemies.stop()
	
func _show_holes():
	for i in range(0,5):
		var screen_size = get_viewport().get_visible_rect().size
		var hole = Hole.instance()
		randomize()
		var x = rand_range(0,screen_size.x)
		var y = rand_range(0,screen_size.y)
		var pos = Vector2(x,y)
		hole.position = pos
		holes_position.append(pos)
		add_child(hole)
		holes.append(hole)

func _spawn_diamond():
	for i in range(0, max_diamond):
		_instatiate_diamond()

func _on_enemy_dead(body):
	active_enemies.erase(body)


func _on_Diamond_timeout():
	var diamond_left = max_diamond - diamond_shown
	for i in range(0, diamond_left):
		_instatiate_diamond()

func _instatiate_diamond():
	var screen_size = get_viewport().get_visible_rect().size
	var diamond = Diamond.instance()
	diamond.connect("body_entered", self, "_on_diamond_eaten")
	randomize()
	var x = rand_range(0,screen_size.x)
	randomize()
	var y = rand_range(0,screen_size.y)
	diamond.position.x = x
	diamond.position.y = y
	diamond_shown += 1
	diamond_list.append(diamond)
	add_child(diamond)
	
func _on_diamond_eaten(body):
	if body.name == "Player":
		$DiamondSound.play()
		diamond_shown -= 1
		score += 1
		$Score.text = str(score)
