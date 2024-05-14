class_name Player
extends Humanoid

static var COYOTE_TIME := 0.1

var coyote_timer := COYOTE_TIME

var input_direction: float:
	get: return Input.get_axis("Left", "Right")

# is the player within the coyote grace period?
var is_on_coyote_floor: bool = false:
	get: return coyote_timer > 0.

func _ready():
	Global.player = self
	super._ready()

# if the player can jump, then they will normal jump
# otherwise code will try to execute an item jump
func jump(delta: float) -> void:
	if is_on_coyote_floor || is_default_jump:
		is_default_jump = true
		coyote_timer = 0
		jump_with_no_horizontal_velocity()
	else:
		for item: Item in items.filter(func(item): return !item.disabled): if item.jump(delta): break

func jump_with_no_horizontal_velocity() -> void:
	velocity.y = JUMP_VELOCITY

# handles a press logic
func a_press(delta: float) -> void:
	if interact_target and is_on_floor():
		interact_target.interact(self)
	else:
		jumping = true

	for item: Item in items.filter(func(item): return !item.disabled): if item.a_press(delta): break

# handles b press logic
func b_press(delta: float) -> void:
	for item: Item in items.filter(func(item): return !item.disabled): if item.b_press(delta): break

func jump_with_horizontal_velocity() -> void:
	if input_direction > 0:
		velocity.x = SPEED
	elif input_direction < 0:
		velocity.x = -SPEED
	jump_with_no_horizontal_velocity()

func _physics_process(delta: float) -> void:
	# Coyote Time Logic
	if is_on_floor() && coyote_timer < COYOTE_TIME:
		coyote_timer = COYOTE_TIME
	elif !is_on_floor() && coyote_timer > 0:
		coyote_timer = move_toward(coyote_timer, 0, delta)

	if Input.is_action_just_pressed("A"):
		a_press(delta)
	elif Input.is_action_just_pressed("B"):
		b_press(delta)

	if Input.is_action_pressed("A") && jumping:
		jump_timer = move_toward(jump_timer, 0, delta)
		if jump_timer > 0:
			jump(delta)
		else:
			is_default_jump = false
	if Input.is_action_just_released("A"):
		jump_timer = JUMP_DURATION
		is_default_jump = false
		jumping = false

		for item in items.filter(func(item): return !item.disabled): item.jump_ended()

	direction = input_direction
	super._physics_process(delta)

func _process(delta: float):
	super._process(delta)
	handle_animation()
