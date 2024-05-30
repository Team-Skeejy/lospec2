class_name MoreTime
extends Behaviour

static var TIME_INCREMENT := 30

func added(holder: Humanoid):
	super.added(holder)
	Modifiers.time += TIME_INCREMENT
