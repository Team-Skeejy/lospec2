class_name StateMachine
extends Node

@export var initial_state : State
var current_state : State
var states : Dictionary = {}


func _ready() -> void:
	for child : Node in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			@warning_ignore("unsafe_property_access", "unsafe_method_access")
			child.transitioned.connect(on_child_transitioned)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	
func _process(delta:float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta:float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transitioned(state:State, new_state_name:String) -> void:
	if state != current_state:
		return
	var new_state : State = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
	
	new_state.Enter()
	
	current_state = new_state

func handle_collision(collision: KinematicCollision2D):
	if current_state.has_method("handle_collision"):
		current_state.handle_collision(collision)
	
func handle_interaction():
	if current_state.has_method('handle_interaction'):
		current_state.handle_interaction()
