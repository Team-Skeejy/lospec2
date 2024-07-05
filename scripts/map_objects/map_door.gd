class_name MapDoor
extends Interactable



var open: bool = false
var boss_locked: bool = false
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: StaticBody2D = $StaticBody2D


func _init():
	interaction_name = "Open"

func interact(_interactor: Humanoid):
	#if !boss_locked:
	if open:
		_close()
	else:
		_open()

func _open():
	sprite.frame = 1
	open = true
	collision.collision_layer = 0
	if Global.player.global_position.x > global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	interaction_name = "Close"

func _close():
	sprite.frame = 0
	open = false
	collision.collision_layer = 1
	interaction_name = "Open"

func enlock():
	sprite.frame = 0
	open = false
	#boss_locked = true
	collision.collision_layer = 1
	interaction_name = "Locked..."
	lock = Lock.new()
	lock.item_needed = load("res://assets/items/lock.tres")
	add_child(lock)
	




