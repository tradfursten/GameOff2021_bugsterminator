extends Node2D


var current_scene
var next_scene

func _ready() -> void:
	Globals.connect("change_level", self, "_on_level_change")
	Globals.connect("loose", self, "_on_loose")
	Globals.connect("player_hp_change", $HUD, "_on_player_hp_change")
	Globals.connect("spray_level_change", $HUD, "_on_spray_level_change")
	Globals.connect("change_level", $HUD, "_on_level_change")
	$HUD.hide()
	current_scene = $Title

func _on_level_change(room):
	print("switcher change level to room, " + room)
	handle_scene_change(room)
	
func handle_scene_change(next_room: String) -> void:
	print("switch to " + next_room)
	next_scene = load("res://src/rooms/" + next_room + ".tscn")
	$AnimationPlayer.play("fade_in")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"fade_in":
			print("fade out")
			remove_child(current_scene)
			current_scene.queue_free()
			current_scene = null
			call_deferred("load_next_scene")
	
func _on_loose():
	next_scene = load("res://src/LooseScreen.tscn")
	$HUD.hide()
	$AnimationPlayer.play("fade_in")

func load_next_scene():
	var new_scene = next_scene.instance()
	add_child(new_scene)
	current_scene = new_scene
	next_scene = null
	$HUD.show()
	$AnimationPlayer.play("fade_out")
	
		
