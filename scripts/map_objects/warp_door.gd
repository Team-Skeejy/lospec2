class_name WarpDoor
extends Interactable

static var TWEEN_SPEED := 0.2
static var TRAVEL_SPEED := 1.

@export var destination: WarpDoor
@export var sprite: AnimatedSprite2D

func _init():
	interaction_name = "Ride"

func interact():
	Global.player.add_item(WarpDoorAnimation.new(self, destination))
	sprite.play()
	sprite.frame = 0