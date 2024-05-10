class_name WallJump
extends Item

var WALL_GRAB_GRACE_PERIOD := 2.
var WALL_GRAB_DEGRADATION_PERIOD := 3.
var WALL_GRAB_DECELLERATION := Global.GRAVITY * -0.9

var wall_grab_timer := WALL_GRAB_GRACE_PERIOD
var wall_grab_degradation_timer := WALL_GRAB_DEGRADATION_PERIOD
var jumping := false
var flip_direction := true  # on lift off, the player needs to go opposite direction, this flips after the user lifts their direction keys
var coyote_timer := Player.COYOTE_TIME
var was_on_wall := false

func _init():
	priority = 1

func jump(_delta: float):
	if !jumping && player.direction && (coyote_timer || player.is_on_wall_only()):
		if player.is_on_wall_only():
			flip_direction = true
		elif coyote_timer:
			flip_direction = false
		jumping = true
		coyote_timer = 0

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
	# coyote timer
	if player.is_on_floor() || player.is_on_ceiling():
		coyote_timer = 0
	elif coyote_timer && !player.is_on_wall_only():
		coyote_timer = move_toward(coyote_timer, 0, delta)

func physics_process(delta: float):
	# coyote timer initialiser
	if !player.is_on_wall_only() && was_on_wall:
		was_on_wall = false
	elif player.is_on_wall_only() && !was_on_wall:
		coyote_timer = Player.COYOTE_TIME
		was_on_wall = true

	# grab grace period
	if player.is_on_wall_only():
		if player.direction && player.velocity.y >= 0:
			if wall_grab_timer > 0:
				wall_grab_timer = move_toward(wall_grab_timer, 0, delta)
				player.velocity.y = 0
				return true
			else:
				wall_grab_degradation_timer = move_toward(wall_grab_degradation_timer, 0, delta)
				player.velocity.y += WALL_GRAB_DECELLERATION * (wall_grab_degradation_timer / WALL_GRAB_DEGRADATION_PERIOD) * delta

	if player.is_on_floor_only():
			wall_grab_timer = WALL_GRAB_GRACE_PERIOD
			wall_grab_degradation_timer = WALL_GRAB_DEGRADATION_PERIOD
	return false
