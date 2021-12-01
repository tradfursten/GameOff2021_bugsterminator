extends Node2D

var song = preload("res://assets/sounds/Bugsterminator.mp3")

#Effects
var room_cleared = preload("res://assets/sounds/room_cleared.wav")
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

#Step on small bugs
var step_on_bugs = [
	preload("res://assets/sounds/step_on_small_bug_1.wav"),
	preload("res://assets/sounds/step_on_small_bug_2.wav"),
	preload("res://assets/sounds/step_on_small_bug_3.wav"),
	preload("res://assets/sounds/step_on_small_bug_4.wav"),
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Music.stream = song


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func play_song():
	$Music.stream = song
	$Music.play()

func play_room_cleared():
	$Effects.stream = room_cleared
	$Effects.play()

		
func play_random_small_bug_step():
	var i = randi() % step_on_bugs.size()
	$Effects.stream = step_on_bugs[i]
	$Effects.play()
