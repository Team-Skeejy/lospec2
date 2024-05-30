class_name BonusPayout
extends Behaviour

static var PAYOUT_INCREMENT := 20

func added(holder: Humanoid):
	super.added(holder)
	Modifiers.payout_bonus += PAYOUT_INCREMENT
