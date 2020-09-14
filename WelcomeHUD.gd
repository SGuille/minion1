extends CanvasLayer
enum {EASY = 1, NORMAL = 2, HARD = 3}
export var dificulty = EASY

func _ready():
	$DifficultyHUD._hide()
	_show()

func _on_Easy_pressed():
	dificulty = EASY
	$DifficultyHUD._hide()
	_show()

func _on_Normal_pressed():
	dificulty = NORMAL
	$DifficultyHUD._hide()
	_show()


func _on_Hard_pressed():
	dificulty = HARD
	$DifficultyHUD._hide()
	_show()

func _show():
	$GameName.visible = true
	$StartGame.visible = true
	$DifficultyButton.visible = true

func _hide():
	$GameName.visible = false
	$StartGame.visible = false
	$DifficultyButton.visible = false

func _on_DifficultyButton_pressed():
	_hide()
	$DifficultyHUD._show()
