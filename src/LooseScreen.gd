extends CanvasLayer

func _ready() -> void:
	$VBoxContainer/Control/LevelLabel.text = str(Globals.level)
	$VBoxContainer/Control2/TimeLabel.text = Globals.get_time()
	$VBoxContainer/Control3/PointsLabel.text = str(Globals.points)

