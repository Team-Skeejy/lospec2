class_name Cash
extends Interactable

@export var value : int = 10 

func _init():
	interaction_name = "Pick up"


func interact(_holder):
	Global.instance.update_money(value)
	Global.instance.new_notification_no_texture("you \"found\" $"+str(value))
	queue_free()
	
