extends KinematicBody2D

signal die
signal small_bugs_attack

enum {
	IDLE,
	WANDER,
	DEAD
}

var hp = 1

var velocity = Vector2.ZERO
var state = IDLE

const ACCELERATION = 300
const MAX_SPEED = 50
const TOLERANCE = 4.0

var damage = 2
var target = null

var last_attack = 0
var attack_delay = 0.5

onready var start_position = global_position
onready var target_position = global_position

func update_target_position():
	var target_vector = Vector2(rand_range(-32, 32), rand_range(-32, 32))
	target_position = start_position + target_vector
	var rot = target_vector.angle()
	look_at(target_position)
	#flip(rot)

func flip(rot):
	#print(rot)
	#var direction = sign(get_global_mouse_position().x - $Sprite.global_position.x)
	if (rot > 0 and rot < PI/2) or (rot < 0 and rot > -PI/2) or rot > 3*PI/2 or rot < -3*PI/2:
		$Sprite.set_flip_h(false)
	else:
		$Sprite.set_flip_h(true)
		
func is_at_target_position(): 
	# Stop moving when at target +/- tolerance
	return (target_position - global_position).length() < TOLERANCE

func _physics_process(delta):
	if not state == DEAD:
		if target != null:
			if $AttackArea.overlaps_body(target):
				velocity = Vector2.ZERO
			else:
				look_at(target.global_position)
				target_position.x = target.global_position.x + rand_range(-64, 64)
				target_position.y = target.global_position.y + rand_range(-64, 64)
		match state:
			IDLE:
				state = WANDER
				# Maybe wait for X seconds with a timer before moving on
				update_target_position()
				$AnimationPlayer.play("walking")
			WANDER:
				accelerate_to_point(target_position, ACCELERATION * delta)

				if is_at_target_position():
					state = IDLE
					$AnimationPlayer.play("idle")

		velocity = move_and_slide(velocity)
		if is_on_wall() and state == WANDER:
			update_target_position()
			
		last_attack += delta

func accelerate_to_point(point, acceleration_scalar):
	var direction = (point - global_position).normalized()
	var acceleration_vector = direction * acceleration_scalar
	accelerate(acceleration_vector)

func accelerate(acceleration_vector):
	velocity += acceleration_vector
	velocity = velocity.clamped(MAX_SPEED)

func spray(_damage):
	call_deferred("kill")

func _on_StepArea_body_entered(body: Node) -> void:
	if body.name == "Player":
		call_deferred("kill")


func _on_AttackArea_body_entered(body: Node) -> void:
	if body.name == "Player" and $AnimationPlayer.current_animation != "attack":
		$AnimationPlayer.play("attack")
		if target == null:
			emit_signal("small_bugs_attack")
			target = body

	
func attack():
	print("attack")
	last_attack = 0

	target.damage(damage)

func small_bugs_attack(player):
	target = player


func kill():
	if state != DEAD:
		Globals.add_points(1)
		state = DEAD
		hp = 0
		$AnimationPlayer.stop()
		$Sprite.frame = randi() % 4 + 8
		$CollisionShape2D.disabled = true
		$StepArea/CollisionShape2D.disabled = true
		$AttackArea/CollisionShape2D.disabled = true
		GlobalAudioPlayer.play_random_small_bug_step()
		emit_signal("die", self.global_position)
		

