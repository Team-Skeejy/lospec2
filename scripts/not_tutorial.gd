extends Node2D

func _ready():
	if Global.instance.current_phase == Global.GamePhase.tutorial_platformer: queue_free()
