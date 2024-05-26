class_name Tutorial
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.instance.current_phase != Global.GamePhase.tutorial:
		queue_free()
