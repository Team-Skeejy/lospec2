class_name Door
extends Interactable

@export_file("*.tscn") var next_scene: String

@export var sprite: AnimatedSprite2D

func interact(_interactor: Humanoid):
	sprite.animation = "open"
	sprite.play()
	if next_scene:
		Global.instance.store_player_and_transition_to(next_scene)
		# FadeTransition.instance.transition_to(next_scene)

func _on_body_entered(body):
	if ! (body is Player): return
	sprite.animation = "ajar"

func _on_body_exited(body):
	if ! (body is Player): return
	sprite.animation = "closed"

var a: Array = []

