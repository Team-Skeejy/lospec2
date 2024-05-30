class_name TalkFaster
extends Behaviour

static var TALK_SPEED_INCREMENT := 0.75

func added(holder: Humanoid):
	super.added(holder)
	Modifiers.talk_speed += TALK_SPEED_INCREMENT
