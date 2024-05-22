class_name NPCPatrol
extends NPCState

@export var position1: Node2D
@export var position2: Node2D
@export var danger_zone: Area2D

func on_danger_zone(body: Node2D):
	if body is Player:
		transitioned.emit(self, "NPCSecurity")

func Enter():
	# if danger_zone is defnied
	if danger_zone:
		# if the player is already in the danger zone
		if danger_zone.get_overlapping_bodies().any(func(body): return body is Player):
			# straight to the security mode
			transitioned.emit(self, "NPCSecurity")
		# if the player enters while patrolling, we go to security
		danger_zone.body_entered.connect(on_danger_zone)

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

	if danger_zone && danger_zone.body_entered.is_connected(on_danger_zone):
		danger_zone.body_entered.disconnect(on_danger_zone)

func _on_arrival():
	# print("arrived")
	npc.on_arrival.disconnect(_on_arrival)
	transitioned.emit(self, "NPCIdle")
