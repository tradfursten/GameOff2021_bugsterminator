extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAudioPlayer.play_song()
	pass # Replace with function body.

func get_name():
	"Title"



func _on_Button_pressed() -> void:
	print("Start game")
	Globals.start_game()
