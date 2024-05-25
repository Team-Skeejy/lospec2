class_name SmallTalkAction
extends Behaviour

var cooldown_timer: SceneTreeTimer
var can_yap: bool = true

func up_press(_delta: float) -> bool:
	if not can_yap:
		return false

	if not (holder is Player):
		print_debug("BUG! LOOK! A BUG! THIS SHOULD NOT HAPPEN!")
		return false

	holder.dialogue_generator.new_dialogue_speech_bubble(SpeechBubble.Type.SMALL_TALK)
	cooldown_timer = get_tree().create_timer(DialogueGenerator.RESPONSE_TIME * 1.1)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	can_yap = false

	var npcs = holder.dialogue_generator.dialogue_area.get_overlapping_bodies().filter(func(x): return x is NPC)
	if npcs:
		npcs[0].dialogue_generator.respond_to_small_talk()

	return false


func _on_cooldown_timer_timeout():
	cooldown_timer.timeout.disconnect(_on_cooldown_timer_timeout)
	can_yap = true
