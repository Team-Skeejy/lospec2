class_name Sittable
extends Interactable

func _init():
	interaction_name = "sit"

func interact(interactor: Humanoid):
		interactor.add_item(Sit.new(self))

