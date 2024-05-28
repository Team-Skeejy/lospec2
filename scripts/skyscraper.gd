extends Node2D

@export var small_talk_manual: ItemResource

func timeout():
	Global.instance.go_to_next_phase()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.instance.time_out.connect(timeout)
	if !Global.is_tutorial() && !Global.player.has_item(small_talk_manual):
		Global.player.add_item(small_talk_manual)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
