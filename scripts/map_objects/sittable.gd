@tool

class_name Sittable
extends Interactable


var _flip: bool
@export var flip: bool:
	set(value):
		_flip = value
		sprite.flip_h = _flip
	get:
		return _flip

@export var sprite: Sprite2D

func _init():
	interaction_name = "sit"

func interact(interactor: Humanoid):
		interactor.add_behaviour.call_deferred(Sit.new(self))
