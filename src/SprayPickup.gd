extends Area2D

func _ready() -> void:
	$AnimationPlayer.play("idle")
	$CollisionShape2D.call_deferred("set_disabled", false)


func _on_SprayPickup_body_entered(body: Node) -> void:
	print("body entered " + body.name)
	if body.name == "Player":
		print("Player picked up")
		Globals.change_spray(25)
		$AnimationPlayer.play("pick_up")

