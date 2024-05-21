class_name TalkFaster
extends Item

static var TALK_SPEED_INCREMENT := 0.5

func added(holder:Humanoid):
	super.added(holder)
	Modifiers.talk_speed += TALK_SPEED_INCREMENT
