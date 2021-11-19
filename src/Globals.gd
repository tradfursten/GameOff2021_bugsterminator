extends Node

signal change_level(room)
signal player_hp_change
signal spray_level_change
signal win
signal loose

const rooms = 6

var player_hp = 100
var max_spray_level = 500
var spray_level = 500
var level = 1
var time_elapsed = 0.0
var points = 0

var playing = false

func _ready() -> void:
	randomize()

func _process(delta: float) -> void:
	if playing:
		time_elapsed += delta
		
func _set_initial_values():
	time_elapsed = 0.0
	points = 0
	level = 1
	player_hp = 100
	spray_level = 500
	max_spray_level = 500
	
func start_game():
	print("Globals: start the game")
	_set_initial_values()
	emit_signal("change_level", "room" + str(level))

	playing = true

func next_level():
	level += 1
	var next_room = randi() % rooms
	print("Next level: " + str(level) + " room" + str(next_room+1))
	emit_signal("change_level", "room"+str(next_room+1))

func take_damage(damage):
	player_hp -= damage
	emit_signal("player_hp_change")	
	if player_hp <= 0:
		playing = false
		emit_signal("loose")


func use_spray():
	spray_level -= 1
	emit_signal("spray_level_change")
	
func change_spray(ammount):
	spray_level += ammount
	if spray_level > max_spray_level:
		max_spray_level = spray_level
	emit_signal("spray_level_change")
	
func change_hp(ammount):
	player_hp += ammount
	if player_hp > 100:
		player_hp = 100
	emit_signal("player_hp_change")
	
func get_enemies_for_level():
	return level + randi() % (level + 1)

func get_time():
	var milliseconds = fmod(time_elapsed, 1) * 100
	var seconds = fmod(time_elapsed, 60)
	var minutes = time_elapsed / 60
	var time_string := "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	return time_string
	
func add_points(p):
	points += p
