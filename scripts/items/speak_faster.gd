class_name TalkFaster
extends Behaviour

static var TALK_SPEED_INCREMENT := 1.0

func added(holder: Humanoid):
	super.added(holder)
	Modifiers.talk_speed += TALK_SPEED_INCREMENT
