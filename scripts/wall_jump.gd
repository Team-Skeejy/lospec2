class_name WallJump
extends Item

var WALL_GRAB_GRACE_PERIOD := 2.
var WALL_GRAB_DECELLERATION := Global.GRAVITY * -0.9

var wall_grab_timer := WALL_GRAB_GRACE_PERIOD
var jumping := false
var flip_direction := true  # on lift off, the player needs to go opposite direction, this flips after the user lifts their direction keys

func jump(_delta: float):
	if !jumping && player.is_on_wall_only() && player.direction:
		jumping = true
		flip_direction = true

	if jumping:
		if Input.is_action_just_released("Left") || Input.is_action_just_released("Right"):
			flip_direction = false

		player.velocity.y = Player.JUMP_VELOCITY
		player.velocity.x = player.direction * Player.SPEED * (-1 if flip_direction else 1)
		return true
	return false

func jump_ended():
	jumping = false

func _physics_process(delta: float):
	if player.is_on_wall_only() && player.direction && player.velocity.y >= 0:
		if wall_grab_timer > 0:
			wall_grab_timer = move_toward(wall_grab_timer, 0, delta)
			override_gravity = true
			player.velocity.y = 0
		else:
			override_gravity = false
			player.velocity.y += WALL_GRAB_DECELLERATION * delta


	else:
			override_gravity = false
			wall_grab_timer = WALL_GRAB_GRACE_PERIOD
