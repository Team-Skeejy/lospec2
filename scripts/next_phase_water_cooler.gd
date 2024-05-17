extends Interactable

func _ready():
	interaction_name = "Next Phase"

func interact(_interactor: Humanoid):
	Global.instance.go_to_next_phase()
