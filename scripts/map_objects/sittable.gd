class_name Sittable
extends Interactable

func _init():
	interaction_name = "sit"

func interact(interactor: Humanoid):
		interactor.add_behaviour.call_deferred(Sit.new(self))
