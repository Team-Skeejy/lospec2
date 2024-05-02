class_name Door
extends Interactable

@export var next_scene: PackedScene
@export var next_scene_name: StringName

@export var sprite: AnimatedSprite2D

func interact():
	sprite.animation = "open"
	sprite.play()
	if next_scene:
		FadeTransition.instance.transition_to(next_scene.duplicate())
	elif next_scene_name:
		FadeTransition.instance.transition_to_name(next_scene_name)


func _on_body_entered(body):
	if ! (body is Player): return
	sprite.animation = "ajar"

func _on_body_exited(body):
	if ! (body is Player): return
	sprite.animation = "closed"

