class_name NPC
extends Humanoid

static var ARRIVAL_THRESHOLD := 8.

signal on_arrival

enum NPCType {
	Jacket,
	Tie,
	Woman
}

@export var company_resource : CompanyResource
@export var lock : Lock
@export var type : NPCType = NPCType.Jacket
@export var navigation_agent: NavigationAgent2D
@export var vision_container: Node2D

@onready var company: String = company_resource.company_name
var INTERACT_THRESHOLD_DISTANCE := 40.

# global destination to walk npc towards
var _destination: Vector2
var destination: Vector2:
	get: return _destination
	set(value):
		arrived = false
		navigation_agent.target_position = value  # tell the navigation agent where you want to go
		_destination = navigation_agent.get_final_position()  # actually do logic on the final *reachable* position
var arrived := true

func _init():
	speed = 40.
	
func _ready():
	if type == NPCType.Jacket:
		sprite.texture = load(company_resource.jacket_spritesheet_path)
	elif type == NPCType.Tie:
		sprite.texture = load(company_resource.tie_spritesheet_path)
	elif type == NPCType.Woman:
		sprite.texture = load(company_resource.woman_spritesheet_path)

func is_within_threshold() -> bool:
	return global_position.distance_to(navigation_agent.get_final_position()) < ARRIVAL_THRESHOLD

func _process(delta):
	if interact_target:  # If the NPC can interact and the next path position is far away, he wants the elevator,
		if position.distance_to(navigation_agent.get_next_path_position()) > INTERACT_THRESHOLD_DISTANCE:
			interact_target.interact(self)
	super._process(delta)
	if vision_container:
		match _facing:
			EDirection.right:
				vision_container.scale.x = 1
			EDirection.left:
				vision_container.scale.x = -1

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
