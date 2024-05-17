class_name NPCPatrol
extends NPCState

@export var position1: Node2D
@export var position2: Node2D

func Enter():
	var dist_to_pos1: float = npc.global_position.distance_to(position1.global_position)
	var dist_to_pos2: float = npc.global_position.distance_to(position2.global_position)
	if dist_to_pos1 < dist_to_pos2:
		npc.destination = position2.global_position
	else:
		npc.destination = position1.global_position

	if not npc.on_arrival.is_connected(_on_arrival):
		npc.on_arrival.connect(_on_arrival)

func Exit():
	if npc.on_arrival.is_connected(_on_arrival):
		npc.on_arrival.disconnect(_on_arrival)

func _on_arrival():
	# print("arrived")
	npc.on_arrival.disconnect(_on_arrival)
	transitioned.emit(self, "NPCIdle")
