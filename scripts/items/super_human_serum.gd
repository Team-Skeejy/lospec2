class_name SuperHumanSerum
extends Behaviour

static var LUCK_INCREMENT := 10
static var JUMP_DURATION_INCREMENT := 0.06
static var JUMP_FORCE_INCREMENT := 25
static var TIME_INCREMENT := 30

func added(holder: Humanoid):
	super.added(holder)
	Modifiers.luck += MoreLuck.LUCK_INCREMENT
	Modifiers.payout_bonus += BonusPayout.PAYOUT_INCREMENT
	Modifiers.jump_duration += MoreJumpHeight.JUMP_DURATION_INCREMENT
	Modifiers.jump_velocity += MoreJumpHeight.JUMP_FORCE_INCREMENT
	Modifiers.time += MoreTime.TIME_INCREMENT
	Global.instance.player.speed += WalkFaster.SPEED_INCREMENT * 2
	
