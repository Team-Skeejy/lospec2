extends Node2D

@export var active: bool = false

func _ready():
	if not active:
		queue_free()

