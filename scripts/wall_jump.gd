class_name WallJump
extends Item

var WALL_GRAB_GRACE_PERIOD := 2.
var WALL_GRAB_DECELLERATION := Global.GRAVITY * -0.9

var wall_grab_timer := WALL_GRAB_GRACE_PERIOD

func jump(_delta: float):
	var direction: float = Input.get_axis("Left", "Right")
	if player.is_on_wall_only() && direction:
		player.velocity.y = Player.JUMP_VELOCITY
		if direction > 0:
			player.velocity.x = -Player.SPEED
		elif direction < 0:
			player.velocity.x = Player.SPEED
		return true
	return false

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
