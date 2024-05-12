class_name WarpDoorAnimation
extends Item

var target: WarpDoor
var source: WarpDoor

var block_physics := true

func _init(src: WarpDoor, tgt: WarpDoor):
	source = src
	target = tgt
	self.animation = "enter"

func added():
	if player.global_position.x > source.global_position.x:
		player.sprite.flip_h = true
	else:
		player.sprite.flip_h = false

	var collision_shapes := player.interaction_area.get_children().filter(func(child): return child is CollisionShape2D)
	for shape in collision_shapes: shape.disabled = true

	var tween: Tween = create_tween()
	tween.tween_property(Global.player, "global_position", source.global_position, WarpDoor.TWEEN_SPEED)

	await player.sprite_animation_player.animation_finished

	animation = "none"

	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(Global.player, "global_position", target.global_position, WarpDoor.TRAVEL_SPEED)
	await tween.finished

	target.arrive()

	animation = "exit"
	await player.sprite_animation_player.animation_finished
	for shape in collision_shapes: shape.disabled = false
	player.remove_item(self)

func removed():
	queue_free()

func physics_process(_delta: float):
	if block_physics:
		player.velocity = Vector2.ZERO
		return true
