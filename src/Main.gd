extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for enemy in $enemies.get_children():
		enemy.connect("die", self, "_on_enemy_die")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_enemy_die():
	var enemies_left = 0
	
	for enemy in $enemies.get_children():
		if enemy.hp > 0:
			enemies_left += 1
	
	$HUD/Bugs_label.text = "Bugs left: " + str(enemies_left)
