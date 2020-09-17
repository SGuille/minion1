extends CanvasLayer

func _hide():
	$DiamondSoundBtn.visible = false
	$BackgroundSoundBtn.visible = false
	$AudioLabel.visible = false
	$BackButtonAudio.visible = false

func _show():
	$DiamondSoundBtn.visible = true
	$BackgroundSoundBtn.visible = true
	$AudioLabel.visible = true
	$BackButtonAudio.visible = true
