class_name WarpDoor
extends Interactable

@export var destination : WarpDoor
@export var sprite : AnimatedSprite2D

func _init():
	interaction_name = "Ride"

func interact():
	sprite.play()
	sprite.frame = 0
	
	Global.player.animation_override = 'door'
	Global.player.controls_override = true
	Global.player.velocity = Vector2()
	
	await Global.player.sprite.animation_finished
	
	Global.player.global_position = destination.global_position
	Global.player.animation_override = 'idle'
	Global.player.controls_override = false
	
	destination.sprite.frame = 2
	destination.sprite.play()
	await get_tree().create_timer(0.1).timeout
	Global.player.animation_override = ''
