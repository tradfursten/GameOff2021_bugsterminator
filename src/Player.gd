extends KinematicBody2D

var SPRAY = preload("res://SprayParticle.tscn")
var MOVEMENT_SPEED = 150
var velocity = Vector2()
var rnd = RandomNumberGenerator.new()

var last_spray = 1
var spray_sound_delay = 0.6

var hp = 100

func _ready() -> void:
	rnd.randomize()
	$AnimationPlayer.play("idle")

func _physics_process(delta: float) -> void:
	var input = Vector2.ZERO
	
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input = input.normalized()
	
	velocity = move_and_slide(input  * MOVEMENT_SPEED)
	
	if velocity.length() > 0.1 and $AnimationPlayer.current_animation != "walk":
		$AnimationPlayer.play("walk")
	elif velocity.length() <= 0.1 and $AnimationPlayer.current_animation != "idle":
		$AnimationPlayer.play("idle")
	
	if Input.is_action_pressed("ui_accept"):
		var spray_particle = SPRAY.instance()
		spray_particle.set_global_position($arm/Position2D.get_global_position())
		spray_particle.set_direction(get_global_mouse_position() - position, rnd)
		last_spray += delta
		if last_spray > spray_sound_delay:
			$SprayPlayer.play()
			last_spray = 0
		get_tree().root.add_child(spray_particle)

	
	$arm.look_at(get_global_mouse_position())
	
	flip()
	#look_at(get_global_mouse_position())

func flip():
	var direction = sign(get_global_mouse_position().x - $Sprite.global_position.x)
	if direction < 0:
		$Sprite.set_flip_h(true)
		$arm.set_flip_v(true)
	else:
		$Sprite.set_flip_h(false)
		$arm.set_flip_v(false)
		
func damage(damage):
	hp -= damage
	$HurtPlayer.play()
	$Camera2D.add_trauma(0.25)
	
	if hp <= 0:
		get_tree().reload_current_scene()
