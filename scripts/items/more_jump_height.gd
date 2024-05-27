class_name MoreJumpHeight
extends Behaviour

static var JUMP_DURATION_INCREMENT := 0.07
static var JUMP_FORCE_INCREMENT := 30

func added(holder: Humanoid):
	super.added(holder)
	Modifiers.jump_duration += JUMP_DURATION_INCREMENT
	Modifiers.jump_velocity += JUMP_FORCE_INCREMENT
