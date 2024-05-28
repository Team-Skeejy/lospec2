class_name Interactable
extends Area2D

var interaction_name: String = ""
#var locked_by: Lock.Type = Lock.Type.none
@export var lock: Lock
@export var shader_sprite: Node2D

signal interacted(interactor: Humanoid)

func entered_interact_area():
	pass

func exited_interact_area():
	shader_sprite.material.set_shader_parameter("active", false)

func interact(_interactor: Humanoid):
	pass

func _interact(_interactor: Humanoid):
	if check_lock():
		interacted.emit(_interactor)
		interact(_interactor)
	pass

func check_lock() -> bool:
	if lock:
		return lock.can_be_opened()
	else:
		return true
