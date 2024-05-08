class_name WarpDoor
extends Interactable

@export var destination : WarpDoor
@export var sprite : AnimatedSprite2D
var tween_speed := 0.2

func _init():
	interaction_name = "Ride"

func interact():
	sprite.play()
	sprite.frame = 0
	
	Global.player.animation_override = 'door'
	Global.player.controls_override = true
	Global.player.velocity = Vector2()
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(Global.player, "global_position", global_position, tween_speed)
	
	if Global.player.global_position.x > global_position.x:
		Global.player.sprite.flip_h = true
	else:
		Global.player.sprite.flip_h = false
		
	
	await Global.player.sprite.animation_finished
	
	Global.player.global_position = destination.global_position
	Global.player.animation_override = 'idle'
	Global.player.controls_override = false
	
	destination.sprite.frame = 2
	destination.sprite.play()
	Global.player.animation_override = ''
