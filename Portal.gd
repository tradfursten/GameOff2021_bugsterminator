extends Node2D

signal portal_entered

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/CollisionShape2D.disabled = true
	$Sprite.visible = false
	$StaticBody2D/CollisionShape2D.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func enable_portal():
	$Area2D/CollisionShape2D.disabled = false
	$Sprite.visible = true
	$StaticBody2D/CollisionShape2D.disabled = false

func _on_Area2D_body_entered(body: Node) -> void:
	if body.name == "Player":
		print("Player entered portal")
		emit_signal("portal_entered")
