class_name Sit
extends Item

var source: Sittable

func _init(src: Sittable) -> void:
	animation = "sit"
	source = src

func added(_holder: Humanoid):
	super.added(_holder)
	if holder.global_position.x > source.global_position.x:
		holder._facing = holder.EDirection.left
	else:
		holder._facing = holder.EDirection.right

	var tween: Tween = create_tween()
	tween.tween_property(holder, "global_position", source.global_position, WarpDoor.TWEEN_SPEED)

func b_press(_delta: float) -> bool:
	holder.remove_item(self)
	return true

func physics_process(_delta: float) -> bool:
	holder.velocity = Vector2.ZERO
	return true