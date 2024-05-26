extends CanvasLayer

func _process(delta):
	if Input.get_axis("A", "B"):
		# TODO
		Global.instance.go_to_next_phase()



func _on_timer_timeout():
	Global.instance.go_to_next_phase()

