extends Node2D

@export var small_talk_manual: ItemResource

func timeout():
	Global.instance.go_to_next_phase()

func _ready():
	Global.instance.time_out.connect(timeout)
	if !Global.is_tutorial() && !Global.player.has_item(small_talk_manual):
		Global.player.add_item(small_talk_manual)

func _process(delta):
	pass
