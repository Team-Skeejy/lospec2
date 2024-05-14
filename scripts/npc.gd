class_name NPC
extends Humanoid

static var ARRIVAL_THRESHOLD := 1.

signal on_arrival

@export var company: String  # TODO set up companies in Global (not strings)

# global destination to walk npc towards
var _destination: Vector2
var destination: Vector2:
	get: return _destination
	set(value):
		if !is_within_threshold():
			arrived = false
		_destination = value

var arrived := true

func is_within_threshold() -> bool:
	return global_position.distance_to(destination) < ARRIVAL_THRESHOLD

func _physics_process(delta: float) -> void:
	if !arrived:
		if is_within_threshold():
			arrived = true
			on_arrival.emit()
		else:
			if global_position.x < destination.x:
				direction = 1
			elif global_position.x > destination.x:
				direction = -1

	super._physics_process(delta)
