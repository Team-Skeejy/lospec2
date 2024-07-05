class_name Interactable
extends Area2D

var interaction_name: String = ""
#var locked_by: Lock.Type = Lock.Type.none
@export var shader_sprite: Node2D
var lock: Lock

signal interacted(interactor: Humanoid)

func entered_interact_area():
	pass

func exited_interact_area():
	if is_instance_valid(shader_sprite) && is_instance_valid(shader_sprite.material):
		shader_sprite.material.set_shader_parameter("active", false)

func interact(_interactor: Humanoid):
	pass

func _interact(_interactor: Humanoid):
	if check_lock():
		interacted.emit(_interactor)
		Global.instance.positive_sfx.play()
		interact(_interactor)
	else:
		Global.instance.denied_sfx.play()

func check_lock() -> bool:
	if lock:
		return lock.can_be_opened()
	else:
		return true
