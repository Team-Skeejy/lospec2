class_name DoubleJump
extends Item

static var MAX_JUMPS: int = 2
var jumps_remaining: int = 2
# @onready var timer: Timer = $Timer
# var active = false
# 	player.first_jump.connect(activate)

func jump(_delta: float) -> bool:
	if jumps_remaining > 0:
		player.jump_with_horizontal_velocity()
		jumps_remaining -= 1
		return true
	return false

func _physics_process(_delta: float):
	if player.is_on_floor():
		jumps_remaining = MAX_JUMPS


# func _physics_process(_delta: float):
# 	if disabled: return

# 	if not active:
# 		return

# 	if player.is_on_floor():
# 		deactivate()
# 		return

# 	if not timer.is_stopped():
# 		return

# 	if Input.is_action_just_pressed("A") and not player.is_on_wall():
# 		player.jump()
# 		jumps_remaining -= 1
# 		if jumps_remaining <= 0: deactivate()

# func activate():
# 	if disabled: return
# 	if MAX_JUMPS <= 1: return
# 	active = true
# 	timer.start()
# 	jumps_remaining = MAX_JUMPS - 1

# func deactivate():
# 	active = false
# 	timer.stop()
