extends CanvasLayer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var last_update = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_player_hp()
	set_spray_level()
	set_level()

func set_player_hp():
	$Container/hp_container/HP_label.text = "HP: " + str(Globals.player_hp)
	
func set_spray_level():
	var level = float(Globals.spray_level) / Globals.max_spray_level * 100
	$SprayLevel/TextureProgress.value = level
	
func _on_player_hp_change():
	set_player_hp()

func _on_spray_level_change():
	set_spray_level()
	
func _on_level_change(_level):
	set_level()
	
func _process(delta: float) -> void:
	set_time()

func set_level():
	$Container/level_container/Level_lable.text = "Level: " + str(Globals.level)

func set_time():
	$Container/timer_container/time_label.text = "Time: " + Globals.get_time()

func hide():
	$Container.visible = false
	$SprayLevel.visible = false
	
func show():
	$Container.visible = true
	$SprayLevel.visible = true
	
