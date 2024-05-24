# I think item is a little bit poorly named
# they're actually heirachical holder behaviour extensions
class_name Behaviour
extends Node

@export var disabled: bool = false

var holder: Humanoid

# overrides animations of the holder
var animation := ""

# the lower the priority, the earlier the item is evaluated in the prio stack
var priority := 0

# executed when item is added to holder inventory using the Player.add_item() method
func added(_holder: Humanoid) -> void:
  holder = _holder

# executed when item is removed from holder inventory using the Player.remove_item() method
# must handle own deletion/reparenting, this only removes item from the holder's item list
func removed() -> void:
  queue_free()
  holder = null

# executed when any non-select non-start button is pressed
# does not override
func any_press(_button: String, _delta: float) -> void:
  pass

# return true to stop propogation
# executed when a is pressed always
func up_press(_delta: float) -> bool:
  return false

# return true to stop propogation
# executed when a is pressed always
func down_press(_delta: float) -> bool:
  return false

# # return true to stop propogation
# # executed when a is pressed always
# func left_press(_delta: float) -> bool:
#  return false

# # return true to stop propogation
# # executed when a is pressed always
# func right_press(_delta: float) -> bool:
#  return false

# return true to stop propogation
# executed when a is pressed always
func a_press(_delta: float) -> bool:
  return false

# return true to stop propogation
# exectued when b is pressed always
func b_press(_delta: float) -> bool:
  return false

# return true to stop propogation
# executed when jump command is issued (nothing to interact with)
func jump(_delta: float) -> bool:
  return false

# for managing jump logic
func jump_ended() -> void:
  pass

# return true to block default physics process in holder
# does not block velocity capping
# this is run after holder control logic
# before default controls and physics
# before move and slide
func physics_process(_delta: float) -> bool:
  return false
