class_name HideDoor
extends Interactable

@export var sprite: AnimatedSprite2D

func _init():
	interaction_name = "hide"

func entered_interact_area():
	sprite.animation = "ajar"

func exited_interact_area():
	sprite.animation = "openclose"

func interact(interactor: Humanoid):
	if interactor.behaviours.any(func(behaviour): return behaviour is Hide): return
	interactor.add_behaviour.call_deferred(Hide.new(self))
	sprite.animation = "openclose"
	sprite.frame = 1
	sprite.play()

func leave(interactor: Humanoid):
	sprite.animation = "openclose"
	sprite.frame = 2
	sprite.play()
	await sprite.animation_finished

	if interactor.interact_target == self:
		sprite.animation = "ajar"
