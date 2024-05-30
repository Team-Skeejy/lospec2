class_name MoreJumpHeight
extends Behaviour

static var JUMP_DURATION_INCREMENT := 0.06
static var JUMP_FORCE_INCREMENT := 25

func added(holder: Humanoid):
	super.added(holder)
	Modifiers.jump_duration += JUMP_DURATION_INCREMENT
	Modifiers.jump_velocity += JUMP_FORCE_INCREMENT
