class_name NPC
extends Humanoid

static var ARRIVAL_THRESHOLD := 8.

signal on_arrival

@export var company: String  # TODO set up companies in Global (not strings)
@export var navigation_agent : NavigationAgent2D


# global destination to walk npc towards
var _destination: Vector2
var destination: Vector2:
	get: return _destination
	set(value):
		arrived = false
		navigation_agent.target_position = value # tell the navigation agent where you want to go
		_destination = navigation_agent.get_final_position() # actually do logic on the final *reachable* position

var arrived := true

func is_within_threshold() -> bool:
	return global_position.distance_to(destination) < ARRIVAL_THRESHOLD


func _physics_process(delta: float) -> void:
	if !arrived:
		if is_within_threshold():
			arrived = true
			on_arrival.emit()
		else:
			if global_position.x < navigation_agent.get_next_path_position().x: 
				direction = 1
			elif global_position.x > navigation_agent.get_next_path_position().x:
				direction = -1
	else:
		direction = 0
	

	super._physics_process(delta)
