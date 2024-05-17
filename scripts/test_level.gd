extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.instance.current_phase = Global.GamePhase.test_platformer
