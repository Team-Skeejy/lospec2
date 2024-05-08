class_name WarpDoorAnimation
extends Item

var target: WarpDoor
var source: WarpDoor

var block_physics := true

func _init(src: WarpDoor, tgt: WarpDoor):
	source = src
	target = tgt
	self.animation = "door"

func added():
	if player.global_position.x > source.global_position.x:
		player.sprite.flip_h = true
	else:
		player.sprite.flip_h = false

	var tween: Tween = create_tween()
	tween.tween_property(Global.player, "global_position", source.global_position, WarpDoor.TWEEN_SPEED)

	await player.sprite.animation_finished


	self.animation = "none"

	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(Global.player, "global_position", target.global_position, WarpDoor.TRAVEL_SPEED)
	await tween.finished

	target.sprite.frame = 2
	target.sprite.play()

	animation = "door"
	await player.sprite.animation_finished
	player.remove_item(self)

func removed():
	queue_free()

func physics_process(_delta: float):
	if block_physics:
		player.velocity = Vector2.ZERO
		return true