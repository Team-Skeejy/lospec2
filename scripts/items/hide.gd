class_name Hide
extends Behaviour

var source: HideDoor

func phase_transition(_phase: Global.GamePhase) -> void:
	if not is_instance_valid(source):
		holder.remove_behaviour(self)

func _init(src: HideDoor):
	source = src
	self.animation = "enter"
	name = "Hide"
	Global.instance.phase_transition.connect(phase_transition)

func added(_holder: Humanoid):
	super.added(_holder)
	if holder.global_position.x > source.global_position.x:
		holder._facing = holder.EDirection.left
	else:
		holder._facing = holder.EDirection.right

	var tween: Tween = create_tween()
	tween.tween_property(holder, "global_position", source.global_position, WarpDoor.TWEEN_SPEED)

	await holder.sprite_animation_player.animation_finished
	animation = "none"

func any_press(_button: String, _delta: float) -> void:
	if not is_instance_valid(source):
		holder.remove_behaviour(self)
		return
	source.leave(holder)
	self.animation = "exit"
	await holder.sprite_animation_player.animation_finished
	if holder: holder.remove_behaviour(self)

func physics_process(_delta: float):
	holder.velocity = Vector2.ZERO
	return true

