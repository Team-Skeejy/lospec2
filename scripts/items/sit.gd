class_name Sit
extends Behaviour

var source: Sittable

func _init(src: Sittable) -> void:
	animation = "sit"
	source = src

func added(_holder: Humanoid):
	super.added(_holder)

	var tween: Tween = create_tween()
	tween.tween_property(holder, "global_position", source.global_position, WarpDoor.TWEEN_SPEED)
	await tween.finished

	if source.flip:
		holder._facing = holder.EDirection.right
	else:
		holder._facing = holder.EDirection.left


func any_press(_button: String, _delta: float) -> void:
	holder.remove_behaviour(self)

func physics_process(_delta: float) -> bool:
	holder.velocity = Vector2.ZERO
	return true
