extends Node2D

func timeout():
	Global.instance.go_to_next_phase()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.instance.time_out.connect(timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
