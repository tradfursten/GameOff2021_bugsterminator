extends Area2D

func _ready() -> void:
	$AnimationPlayer.play("idle")
	$CollisionShape2D.call_deferred("set_disabled", false)
	$Sprite.set_scale(Vector2(0.5, 0.5))


func _on_HeartPickup_body_entered(body: Node) -> void:
	print("body entered " + body.name)
	if body.name == "Player":
		print("Player picked up")
		Globals.change_hp(15)
		$AnimationPlayer.play("pick_up")

