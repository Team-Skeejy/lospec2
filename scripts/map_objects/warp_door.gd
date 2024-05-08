class_name WarpDoor
extends Interactable

static var TWEEN_SPEED := 0.2
static var TRAVEL_SPEED := 1.

@export var destination: WarpDoor
@export var sprite: AnimatedSprite2D
var arriving := false

func _init():
	interaction_name = "Ride"

func entered_interact_area():
	if !arriving:
		sprite.animation = "ajar"

func exited_interact_area():
	sprite.animation = "openclose"
	# sprite.frame = 0

func interact():
	Global.player.add_item(WarpDoorAnimation.new(self, destination))
	sprite.animation = "openclose"
	sprite.frame = 1
	sprite.play()

func arrive():
	arriving = true
	sprite.animation = "openclose"
	sprite.frame = 2
	sprite.play()
	await sprite.animation_finished
	arriving = false

	if Global.player.interact_target == self:
		sprite.animation = "ajar"