class_name WarpDoor
extends Interactable

static var TWEEN_SPEED := 0.2
static var TRAVEL_SPEED := 1.

@export var destination: WarpDoor
@export var sprite: AnimatedSprite2D

var arriving := false
var last_interactor: Humanoid

func _init():
	interaction_name = "Ride"

func entered_interact_area():
	if !arriving:
		sprite.animation = "ajar"

func exited_interact_area():
	sprite.animation = "openclose"
	# sprite.frame = 0

func interact(interactor: Humanoid):
	interactor.add_behaviour(WarpTo.new(self, destination))
	sprite.animation = "openclose"
	sprite.frame = 1
	sprite.play()

func arrive(interactor: Humanoid):
	arriving = true
	sprite.animation = "openclose"
	sprite.frame = 2
	sprite.play()
	await sprite.animation_finished
	arriving = false

	if interactor.interact_target == self:
		sprite.animation = "ajar"
