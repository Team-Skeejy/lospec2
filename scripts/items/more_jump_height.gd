class_name MoreJumpHeight
extends Behaviour

static var JUMP_DURATION_INCREMENT := 0.1

func added(holder: Humanoid):
	super.added(holder)
	Modifiers.jump_duration += JUMP_DURATION_INCREMENT
