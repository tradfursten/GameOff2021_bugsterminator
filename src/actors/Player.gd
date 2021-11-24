extends KinematicBody2D

var SPRAY = preload("res://src/SprayParticle.tscn")
var MOVEMENT_SPEED = 150
var velocity = Vector2()
var rnd = RandomNumberGenerator.new()
var deadzone = 0.1

var last_spray = 1
var spray_sound_delay = 0.6

var input_controller = false
var touch_controller = null
var input_enabled = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton:
		input_controller = true
	elif event is InputEventMouseButton:
		input_controller = false
	
func _ready() -> void:
	$Camera2D.current = true
	rnd.randomize()
	$AnimationPlayer.play("idle")

func _physics_process(delta: float) -> void:
	var input = Vector2.ZERO
	
	if input_enabled:
		#var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		
		input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

		if not input_controller:
			$arm.look_at(get_global_mouse_position())
			if $arm.rotation > 2*PI or $arm.rotation < -2 * PI:
				$arm.rotation = $arm.rotation / (2*PI)
			flip($arm.rotation)
		else:
			var look_at = Vector2.ZERO
			look_at.x = Input.get_joy_axis(0, JOY_AXIS_2)
			look_at.y = Input.get_joy_axis(0, JOY_AXIS_3)
			if abs(look_at.x) > deadzone and abs(look_at.y) > deadzone and look_at.angle() != $arm.rotation:
				$arm.rotation = look_at.angle()
				flip($arm.rotation)
		
		if Input.is_action_pressed("ui_accept") and Globals.spray_level > 0:
			spray(delta)

		
	input = input.normalized()
	
	velocity = move_and_slide(input  * MOVEMENT_SPEED)

	if Globals.player_hp > 0:
		if velocity.length() > 0.1 and $AnimationPlayer.current_animation != "walk":
			$AnimationPlayer.play("walk")
		elif velocity.length() <= 0.1 and $AnimationPlayer.current_animation != "idle":
			$AnimationPlayer.play("idle")
		
func spray(delta):
	var spray_particle = SPRAY.instance()
	spray_particle.set_global_position($arm/Position2D.get_global_position())
	var dir = Vector2.RIGHT.rotated($arm.rotation)
	spray_particle.set_direction(dir, rnd)
	last_spray += delta
	if last_spray > spray_sound_delay:
		$SprayPlayer.play()
		last_spray = 0
	Globals.use_spray()
	get_tree().root.add_child(spray_particle)
	
func flip(rot):
	#print(rot)
	#var direction = sign(get_global_mouse_position().x - $Sprite.global_position.x)
	if (rot > 0 and rot < PI/2) or (rot < 0 and rot > -PI/2) or rot > 3*PI/2 or rot < -3*PI/2:
		$Sprite.set_flip_h(false)
		$arm.set_flip_v(false)
	else:
		$Sprite.set_flip_h(true)
		$arm.set_flip_v(true)

		
func damage(damage):
	Globals.take_damage(damage)

	if Globals.player_hp <= 0:
		$AnimationPlayer.play("die")
	else:
		$HurtPlayer.play()
		$Camera2D.add_trauma(0.1)

func loose():
	Globals.loose()

func pick_up():
	print("Player pick up")

func hide_arm():
	$arm.visible = false

func disable_input():
	velocity = Vector2()
	input_enabled = false

func enable_input():
	input_enabled = true
