extends CanvasLayer

var enabled = true

var move_vector = Vector2.ZERO
var aim_vector = Vector2(-1, 0)
var fire = false

func _ready():
	enabled = OS.has_touchscreen_ui_hint()
		
func _input(event: InputEvent) -> void:
	if enabled:
		if event is InputEventScreenTouch or event is InputEventScreenDrag:
			if $LeftJoystick.is_pressed():
				$LeftJoystick/InnerCircle.global_position = event.position
				$LeftJoystick/InnerCircle.visible = true
				move_vector = calculate_move_vector(event.position)
			else:
				$LeftJoystick/InnerCircle.visible = false
				move_vector = Vector2.ZERO
			if $RightJoystick.is_pressed():
				$RightJoystick/InnerCircle.global_position = event.position
				$RightJoystick/InnerCircle.visible = true
				aim_vector = calculate_aim_vector(event.position)
			else:
				$RightJoystick/InnerCircle.visible = false
				#move_vector = Vector2.ZERO
			if $FireButton.is_pressed():
				fire = true
			else:
				fire = false


func calculate_move_vector(position):
	var center = $LeftJoystick.position + Vector2(69, 69)
	return (position - center).normalized()
	
func calculate_aim_vector(position):
	var center = $RightJoystick.position + Vector2(69, 69)
	return (position - center).normalized()
	
func hide():
	$LeftJoystick.visible = false
	$RightJoystick.visible = false
	$FireButton.visible = false
	
func show():
	$LeftJoystick.visible = true
	$RightJoystick.visible = true
	$FireButton.visible = true
