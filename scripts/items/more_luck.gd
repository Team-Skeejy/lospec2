class_name MoreLuck
extends Behaviour

static var LUCK_INCREMENT := 10

func added(holder: Humanoid):
	super.added(holder)
	Modifiers.luck += LUCK_INCREMENT
	

	
