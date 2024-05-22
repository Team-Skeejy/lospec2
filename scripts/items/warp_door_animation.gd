class_name WarpTo
extends Behaviour

var target: WarpDoor
var source: WarpDoor

func _init(src: WarpDoor, tgt: WarpDoor):
	source = src
	target = tgt
	self.animation = "enter"

func added(_holder: Humanoid):
	super.added(_holder)
	if holder.global_position.x > source.global_position.x:
		holder._facing = holder.EDirection.left
	else:
		holder._facing = holder.EDirection.right

	var collision_shapes := holder.interaction_area.get_children().filter(func(child): return child is CollisionShape2D)
	for shape in collision_shapes: shape.disabled = true

	var tween: Tween = create_tween()
	tween.tween_property(holder, "global_position", source.global_position, WarpDoor.TWEEN_SPEED)

	await holder.sprite_animation_player.animation_finished

	animation = "none"

	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(holder, "global_position", target.global_position, WarpDoor.TRAVEL_SPEED)
	await tween.finished

	target.arrive(holder)

	animation = "exit"
	await holder.sprite_animation_player.animation_finished
	for shape in collision_shapes: shape.disabled = false
	holder.remove_item(self)

func removed():
	queue_free()

func physics_process(_delta: float):
	holder.velocity = Vector2.ZERO
	return true
