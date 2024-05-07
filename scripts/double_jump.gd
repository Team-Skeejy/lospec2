class_name DoubleJump
extends Item

static var MAX_JUMPS: int = 2
var jumps_remaining: int = 2
var jumping := false

func jump(_delta: float) -> bool:
	if !jumping && jumps_remaining > 0:
		jumps_remaining -= 1
		jumping = true

	if jumping:
		player.jump_with_horizontal_velocity()
		return true
	return false

func jump_ended():
	jumping = false

func physics_process(_delta: float):
	if player.is_on_coyote_floor:
		jumps_remaining = MAX_JUMPS
	return false
