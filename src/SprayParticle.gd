extends Area2D

const FIREBALL_SPEED = 300

var direction = Vector2()

func _ready() -> void:
	$AnimationPlayer.play("shoot")
	pass

func _process(delta):
	var motion = direction * FIREBALL_SPEED
	position = position + motion * delta

func set_direction(target, rnd):
	var t = target.normalized()
	direction = Vector2(rnd.randf_range(t.x - 0.5, t.x + 0.5), rnd.randf_range(t.y - 0.5, t.y + 0.5)).normalized()

func _on_Timer_timeout() -> void:
	queue_free()

func _on_Spray_body_entered(body: Node) -> void:
	if body.has_method('spray'):
		body.spray(3)

