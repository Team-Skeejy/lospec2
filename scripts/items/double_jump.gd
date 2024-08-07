class_name DoubleJump
extends Behaviour

static var MAX_JUMPS: int = 1
var jumps_remaining: int = 2
var jumping := false

func _init():
	priority = 2


func reset_animation():
	await holder.sprite_animation_player.animation_finished
	animation = ""


func jump(_delta: float) -> bool:
	if !jumping && jumps_remaining > 0:
		if holder is Player: (holder as Player).jump_audio.play()
		jumps_remaining -= 1
		jumping = true

		animation = "jump_x2"
		reset_animation()

	if jumping:
		holder.jump_with_horizontal_velocity()
		return true

	return false


func jump_ended():
	jumping = false


func physics_process(_delta: float):
	if holder.is_on_coyote_floor:
		jumps_remaining = MAX_JUMPS
	return false
