extends Node2D

@export var small_talk_manual: ItemResource

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.instance.current_phase = Global.GamePhase.test_platformer
	Global.player.add_item(small_talk_manual)