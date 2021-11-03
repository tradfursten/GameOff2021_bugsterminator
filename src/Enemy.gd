extends KinematicBody2D

signal die

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var hp = 100
export var damage = 10

const SPEED = 110

enum STATES {IDLE, CHASING, FLEEING, ATTACKING}

var current_state = STATES.IDLE
var player = null
var velocity = Vector2.ZERO

var last_attack = 0
var attack_delay = 1

func _ready() -> void:
	$AnimationPlayer.play("idle")
	
func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	match current_state:
		STATES.CHASING:
			direction = (player.get_global_position() - get_global_position()).normalized()
		STATES.ATTACKING:
			if last_attack + delta > attack_delay:
				$AnimationPlayer.play("attack")
			else:
				last_attack += delta
			
	velocity = move_and_slide(direction * SPEED)
	
	if direction.x > 0:
		$Sprite.flip_h = true
	elif direction.x < 0:
		$Sprite.flip_h = false
	
	
	transition_state()

func spray(damage):
	hp -= damage
	print("Hit by spray")
	
	if hp <= 0:
		print("die")
		$Sprite.show_on_top = true
		z_index = 1
		$AnimationPlayer.play("die")
	transition_state()

func attack():
	player.damage(damage)
	transition_state()
	last_attack = 0

func emit_die():
	queue_free()
	emit_signal("die")

func transition_state():
	if hp < 20:
		current_state = STATES.FLEEING
		return
	if player == null:
		current_state = STATES.IDLE
		return
		
	if $threat_detection.overlaps_body(player):
		current_state = STATES.CHASING
		
	if $attack_area.overlaps_body(player):
		current_state = STATES.ATTACKING
	

func _on_threat_detection_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player = body
		if current_state != STATES.FLEEING:
			current_state = STATES.CHASING


func _on_attack_area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		current_state = STATES.ATTACKING
		player = body
		$AnimationPlayer.play("attack")
