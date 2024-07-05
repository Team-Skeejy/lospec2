class_name WallJump
extends Behaviour

var WALL_GRAB_GRACE_PERIOD := 2.  # how long the player can hold onto a wall for without sliding
var WALL_GRAB_DEGRADATION_PERIOD := 3.  # how long takes for the grab to taper off
var WALL_GRAB_DECELLERATION: float = -Global.GRAVITY  # maximum amount of slow the player experiences holding onto the wall

var wall_grab_timer := WALL_GRAB_GRACE_PERIOD  # timer for how long the player can grab onto the wall for
var wall_grab_degradation_timer := WALL_GRAB_DEGRADATION_PERIOD  # timer to ease back into using full gravity
var jumping := false  # whether or not to process using walljump logic
var wall_jumping := false  # whether or not to continue processing jump like a wall jump
# var flip_direction := true  # on lift off, the player needs to go opposite direction, this flips after the user lifts their direction keys
var coyote_timer := Player.COYOTE_TIME  # used to give lenience for when to walljump
var was_on_wall := false  # used to initialise coyote timer

var direction: Humanoid.EDirection = Humanoid.EDirection.right

func _init():
	priority = 1

func jump(_delta: float):
	if !jumping:
		if holder.input_direction && (coyote_timer || holder.is_on_wall_only()):
			if holder.is_on_wall_only():
				direction = holder.which_wall()
			# elif coyote_timer:
			# 	flip_direction = false
			if holder is Player: (holder as Player).jump_audio.play()
			jumping = true
			wall_jumping = true
			coyote_timer = 0
		else:
			wall_jumping = false


	if jumping:
		# if Input.is_action_just_released("Left") || Input.is_action_just_released("Right"):
		# 	flip_direction = false

		holder.velocity.y = Player.JUMP_VELOCITY
		holder.velocity.x = holder.speed * (-1 if direction == Humanoid.EDirection.left else 1)  #holder.input_direction * holder.speed #* (-1 if flip_direction else 1)
		return true
	return false

func jump_ended():
	jumping = false

func _physics_process(delta: float):
	# coyote timer
	if holder.is_on_floor() || holder.is_on_ceiling():
		coyote_timer = 0
	elif coyote_timer && !holder.is_on_wall_only():
		coyote_timer = move_toward(coyote_timer, 0, delta)

func physics_process(delta: float):
	# coyote timer initialiser
	if !holder.is_on_wall_only() && was_on_wall:
		was_on_wall = false
	elif holder.is_on_wall_only() && !was_on_wall:
		coyote_timer = Player.COYOTE_TIME
		was_on_wall = true

	# grab grace period
	if holder.is_on_wall_only():
		if holder.input_direction && holder.velocity.y >= 0:
			if wall_grab_timer > 0:
				animation = "wall_grab"
				wall_grab_timer = move_toward(wall_grab_timer, 0, delta)
				holder.velocity.y = 0
				return true
			else:
				animation = "wall_slide"
				wall_grab_degradation_timer = move_toward(wall_grab_degradation_timer, 0, delta)
				holder.velocity.y += WALL_GRAB_DECELLERATION * (wall_grab_degradation_timer / WALL_GRAB_DEGRADATION_PERIOD) * delta
	elif wall_jumping:
		if holder.velocity.y > 0:
			animation = "wall_jump_fall"
		elif holder.velocity.y < 0:
			animation = "wall_jump_rise"
	else:
		animation = ""

	if holder.is_on_floor_only():
			wall_jumping = false
			wall_grab_timer = WALL_GRAB_GRACE_PERIOD
			wall_grab_degradation_timer = WALL_GRAB_DEGRADATION_PERIOD
	return false
