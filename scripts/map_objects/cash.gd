class_name Cash
extends Interactable

@export var value : int = 10 

signal picked_up(c: Cash)

func _init():
	interaction_name = "Pick up"


func interact(_holder):
	Global.instance.update_money(value)
	Global.instance.new_notification_no_texture("you \"found\" $"+str(value))
	picked_up.emit(self)
	queue_free()
	
