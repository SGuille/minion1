extends CanvasLayer

func _ready():
	_hide()

func _hide():
	$GameOver.visible = false
	$NewGame.visible = false

func _show():
	$GameOver.visible = true
	$NewGame.visible = true
