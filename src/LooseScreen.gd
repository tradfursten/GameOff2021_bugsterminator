extends CanvasLayer

func _ready() -> void:
	$VBoxContainer/Control/LevelLabel.text = str(Globals.level)
	$VBoxContainer/Control2/TimeLabel.text = Globals.get_time()
	$VBoxContainer/Control3/PointsLabel.text = str(Globals.points)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Button_pressed() -> void:
	print("Start game")
	Globals.start_game()
