class_name WalkABitFaster
extends Behaviour

static var SPEED_INCREMENT := 5

func added(holder: Humanoid):
	super.added(holder)
	holder.speed += SPEED_INCREMENT
