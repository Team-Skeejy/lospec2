class_name Item
extends Node

@export var disabled: bool = false

var player: Player:
  get: return Global.player

var override_gravity := false
var animation := ""

# return true to stop propogation
# executed when a is pressed always
func a_press(delta: float) -> bool:
  return false

# return true to stop propogation
# exectued when b is pressed always
func b_press(delta: float) -> bool:
  return false

# return true to stop propogation
# executed when jump command is issued (nothing to interact with)
func jump(delta: float) -> bool:
  return false

func jump_ended() -> void:
  pass

func physics_process(delta: float) -> bool:
  return false