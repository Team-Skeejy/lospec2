class_name NPCPatrol
extends NPCState

@export var on_alert: String
@export var on_idle: String


@export var danger_zone: Area2D

func Enter():
	var dist_to_pos1: float = npc.global_position.distance_to(npc.patrol_position1.global_position)
	var dist_to_pos2: float = npc.global_position.distance_to(npc.patrol_position2.global_position)
	if dist_to_pos1 < dist_to_pos2:
		npc.destination = npc.patrol_position2.global_position
	else:
		npc.destination = npc.patrol_position1.global_position

	if not npc.on_arrival.is_connected(_on_arrival):
		npc.on_arrival.connect(_on_arrival)

func Update(_delta: float):
	if !danger_zone: return
	var players := danger_zone.get_overlapping_bodies().filter(func(body): return body is Player)
	for player in players:
		if player.behaviours.any(func(behaviour): return behaviour is Hide):
			continue
		else:
			npc.arrived = true
			transitioned.emit(self, on_alert)

func Exit():
	if npc.on_arrival.is_connected(_on_arrival):
		npc.on_arrival.disconnect(_on_arrival)

func _on_arrival():
	# print("arrived")
	npc.on_arrival.disconnect(_on_arrival)
	transitioned.emit(self, on_idle)
