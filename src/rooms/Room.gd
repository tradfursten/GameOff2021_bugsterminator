extends Node2D

var ANT = preload("res://src/actors/Ant.tscn")
var SMALL_BUG = preload("res://src/actors/SmallBug.tscn")
var PLAYER = preload("res://src/actors/Player.tscn")
var PORTAL = preload("res://src/Portal.tscn")
var SPRAY_PICKUP = preload("res://src/SprayPickup.tscn")
var HEART_PICKUP = preload("res://src/HeartPickup.tscn")

var portal = null
var room_cleared = false

var enemies = 0
var player

func _ready() -> void:
	print("Loading room " + self.name)
	$CanvasModulate.visible = true
	#print($CanvasModulate.visible)
	var spawn_points = []
	for c in $spawn_points.get_children():
		if c.is_in_group("spawn_points"):
			spawn_points.append(c)
	
	randomize()
	var rand_index:int = randi() % spawn_points.size()
	portal = PORTAL.instance()
	$portal.add_child(portal)
	portal.set_global_position(spawn_points[rand_index].global_position)
	portal.connect("portal_entered", self, "_on_portal_entered")
	
	player = PLAYER.instance()
	
	$player.add_child(player)
	player.set_global_position(spawn_points[rand_index].global_position)
	
	spawn_points.remove(rand_index)
	Globals.connect("spray_level_change", self, "_on_spray_level_change")
	
	for i in Globals.get_enemies_for_level():
		var area = $spawn_areas.get_child(randi() % $spawn_areas.get_child_count())
		var enemy = ANT.instance()
		$enemies.add_child(enemy)
		var p = get_position_without_player_threat(area, player.position)
		enemy.set_global_position(p)
		enemy.add_to_group("enemies")
		enemy.connect("die", self, "_on_enemy_die")
		enemies += 1
	
	for i in 5:
		var area = $spawn_areas.get_child(randi() % $spawn_areas.get_child_count())
		for j in 5:
			var target_vector = Vector2(rand_range(-32, 32), rand_range(-32, 32))
			var target_position = area.rect_position + Vector2(area.rect_size.x * randf(), area.rect_size.y * randf())
			var bug = SMALL_BUG.instance()
			bug.set_global_position(target_position)
			bug.add_to_group("enemies")
			bug.connect("die", self, "_on_enemy_die")
			bug.connect("small_bugs_attack", self, "_on_small_bugs_attack")
			$enemies.add_child(bug)
			enemies += 1
			
	player.enable_input()
		
func get_position_without_player_threat(area, player_pos):
	var p = player_pos
	while p.distance_to(player_pos) < 132.0:
		p = area.rect_position + Vector2(area.rect_size.x * randf(), area.rect_size.y * randf())
	return p
	
func _process(delta: float) -> void:
	if not room_cleared:
		var clear = true
		for e in $enemies.get_children():
			if e.hp > 0:
				clear = false
				break
		if clear:
			room_cleared = true
			GlobalAudioPlayer.play_room_cleared()
			portal.enable_portal(player)
			
func _on_portal_entered():
	player.disable_input()
	Globals.change_spray(100)
	Globals.next_level()
	
func _on_enemy_die(position):
	enemies -= 1
	if (randi() % 100) < 25:
		var pickup = SPRAY_PICKUP.instance()
		pickup.global_position = position
		pickup.add_to_group("pickups")
		add_child(pickup)
	elif (randi() % 100) < 25:
		var pickup = HEART_PICKUP.instance()
		pickup.global_position = position
		pickup.add_to_group("pickups")
		add_child(pickup)

func _on_spray_level_change():
	if Globals.spray_level <= 0:
		print("Spray is zero should exit?")
		if not can_get_spray():
			Globals.loose()

func can_get_spray():
	var can_get_spray = false
	var cleared = true
	for e in $enemies.get_children():
		if e.get_class() == "SmallBug":
			print("Chance of getting spray from small bug")
			return true
		if e.hp <= 0:
			print("Getting spray from level cleared")
			cleared = false
	if cleared:
		return true
	for p in get_tree().get_nodes_in_group("pickups"):
		if p.get_class() == "SprayPickup":
			print("Getting spray from spray pickup")
			return true

func _on_small_bugs_attack():
	print("small bugs attack")
	for e in $enemies.get_children():
		if e.has_method("small_bugs_attack"):
			e.small_bugs_attack(player)
	
