extends Node2D

export (PackedScene) var Enemy
export (PackedScene) var Hole
export (PackedScene) var Diamond

var score = 0
var diamond_shown = 0
var max_enemies = 30
var max_diamond = 15
var holes = []
var diamond_list = []
var holes_position = []
var active_enemies = []

func _process(_delta):
	_follow_player()

func _follow_player():
	for enemy in active_enemies:
		if (enemy != null):
			enemy.player_position = $Player.position

func _on_StartGame_pressed():
	max_diamond = 15
	diamond_shown = 0
	score = 0
	$Score.text = str(score)
	$WelcomeHUD._hide()
	$DiamondTimer.start()
	$Enemies.start()
	if (!$BackgroundSound.playing && $WelcomeHUD/OptionsHUD.backgroundSound):
		$BackgroundSound.play()
	_show_player()
	_spawn_diamonds()
	_show_holes()
	
func _on_Menu_pressed():
	$GameOverHUD._hide()
	$GamerOverSound.stop()
	$WelcomeHUD._show()
	$Score.text = str(0)
	
func _show_enemy():
	randomize()
	var position = randi()%4
	var enemy = Enemy.instance()
	enemy.position = holes_position[position]
	enemy.connect("hit", self, "_on_Player_hit")
	enemy.connect("die", self, "_on_enemy_dead")
	enemy.speed = enemy.speed * $WelcomeHUD/OptionsHUD.dificulty
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
	_clean_all_elements()
	
func _clean_all_elements():
	var array = [holes, active_enemies, diamond_list]
	for elements in array: _clean_elements(elements)
	holes = []
	diamond_list = []
	active_enemies = []
	holes_position = []
	$Player.hide()
	$DiamondTimer.stop()
	$Enemies.stop()
	
func _clean_elements(elements):
	for element in elements:
			element.hide()
			element.set_deferred("disabled", true)
			element.queue_free()
	
func _show_holes():
	for _i in range(5):
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

func _spawn_diamonds():
	for _i in range(max_diamond):
		_spawn_diamond()

func _on_enemy_dead(body):
	active_enemies.erase(body)

func _on_Diamond_timeout():
	var diamond_left = max_diamond - diamond_shown
	for _i in range(diamond_left):
		_spawn_diamond()

func _spawn_diamond():
	var screen_size = get_viewport().get_visible_rect().size
	var diamond = Diamond.instance()
	diamond.connect("body_entered", self, "_on_diamond_eaten")
	randomize()
	var x = rand_range(0,screen_size.x)
	var y = rand_range(0,screen_size.y)
	diamond.position.x = x
	diamond.position.y = y
	diamond_shown += 1
	diamond_list.append(diamond)
	add_child(diamond)
	
func _on_diamond_eaten(body):
	if body.name == "Player":
		if $WelcomeHUD/OptionsHUD.diamondSound: $DiamondSound.play()
		diamond_shown -= 1
		score += 1
		$Score.text = str(score)
