extends KinematicBody2D

signal die(position)

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var hp = 100
export var damage = 10

const SPEED = 110

enum STATES {IDLE, CHASING, DEAD, ATTACKING}

var current_state = STATES.IDLE
var player = null
var velocity = Vector2.ZERO

var last_attack = 0
var attack_delay = 0.6

func _ready() -> void:
	$AnimationPlayer.play("idle")
	$Sprite.material.set_shader_param("active", false)
	
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
	
	if velocity.length() > 0 and $AnimationPlayer.current_animation != "walking":
		$AnimationPlayer.play("walk")
	
	if direction.x > 0:
		$Sprite.flip_h = true
	elif direction.x < 0:
		$Sprite.flip_h = false
	
	
	transition_state()

func spray(d):
	hp -= d
	print("Hit by spray")
	$HitPlayer.play("hit")
	
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
	emit_signal("die", self.global_position)
	Globals.add_points(10)
	queue_free()


func transition_state():
	if player == null:
		current_state = STATES.IDLE
		return
		
	if $threat_detection.overlaps_body(player):
		current_state = STATES.CHASING
		
	if $attack_area.overlaps_body(player):
		current_state = STATES.ATTACKING
	
	if hp <= 0:
		current_state = STATES.DEAD
	

func _on_threat_detection_body_entered(body: Node) -> void:
	if body.name == "Player":
		player = body
		if current_state != STATES.DEAD:
			current_state = STATES.CHASING


func _on_attack_area_body_entered(body: Node) -> void:
	if body.name == "Player":
		current_state = STATES.ATTACKING
		player = body
		$AnimationPlayer.play("attack")
