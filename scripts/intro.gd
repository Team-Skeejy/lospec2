extends Node2D

func _on_timer_timeout():
	Global.instance.go_to_next_phase()
