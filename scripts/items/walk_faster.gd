class_name WalkFaster
extends Behaviour

static var SPEED_INCREMENT := 20

func added(holder: Humanoid):
	super.added(holder)
	holder.speed += SPEED_INCREMENT
