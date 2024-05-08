# I think item is a little bit poorly named
# they're actually heirachical player behaviour extensions
class_name Item
extends Node

@export var disabled: bool = false

var player: Player:
  get: return Global.player

# overrides animations of the player
var animation := ""

# the lower the priority, the earlier the item is evaluated in the prio stack
var priority := 0

# executed when item is added to player inventory using the Player.add_item() method
func added() -> void:
  pass

# executed when item is removed from player inventory using the Player.remove_item() method
# must handle own deletion/reparenting, this only removes item from the player's item list
func removed() -> void:
  pass

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

# for managing jump logic
func jump_ended() -> void:
  pass

# return true to block default physics process in player
# does not block velocity capping
# this is run after player control logic
# before default controls and physics
# before move and slide
func physics_process(delta: float) -> bool:
  return false
