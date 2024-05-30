class_name NPCBoss
extends NPCState

@export var talk_zone: Area2D

func Enter() -> void:
	pass
	await get_tree().create_timer(0.5).timeout
	# place the boss on a chair so he sits immediately
	if npc.interact_target:
		npc.interact_target._interact(npc)
