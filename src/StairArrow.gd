extends Node2D

onready var sprite = $Arrow
var target = null

func _physics_process(delta: float) -> void:
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	
	set_arrow_position(Rect2(top_left, size))
	set_arrow_rotation()
	

func set_arrow_position(bounds: Rect2):
	if target == null:
		return
	else:
		var target_position = target.global_position
		var displacement = global_position - target_position
		var length
		
		var tl = (bounds.position - target_position).angle()
		var tr = (Vector2(bounds.end.x, bounds.position.y) - target_position).angle()
		var bl = (Vector2(bounds.position.x, bounds.end.y) - target_position).angle()
		var br = (bounds.end - target_position).angle()
		
		if (displacement.angle() > tl && displacement.angle() < tr) \
				|| (displacement.angle() < bl && displacement.angle() > br):
			var y_length = clamp(displacement.y, bounds.position.y - target_position.y, \
				bounds.end.y - target_position.y)
			var angle = displacement.angle() - PI / 2
			length = y_length / cos(angle) if cos(angle) != 0 else y_length
		else:
			var x_length = clamp(displacement.x, bounds.position.x - target_position.x, \
				bounds.end.x - target_position.x)
			var angle = displacement.angle()
			length = x_length / cos(angle) if cos(angle) != 0 else x_length
		
		sprite.global_position = polar2cartesian(length - 15, displacement.angle()) + target_position
		
	if bounds.has_point(global_position):
		hide()
	else:
		show()
		
func set_arrow_rotation():
	var angle = (global_position - sprite.global_position).angle()
	sprite.global_rotation = angle
