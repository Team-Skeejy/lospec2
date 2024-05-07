class_name Player
extends CharacterBody2D

static var SPEED := 100.
static var ACCELERATION := 900.
static var AERIAL_ACCELERATION := 800.
static var FRICTION := 1600.
static var AIR_FRICTION := 1000.
static var JUMP_VELOCITY := -200.
static var COYOTE_TIME := 0.2
static var JUMP_DURATION := 0.5

@export var sprite: AnimatedSprite2D
@export var interaction_area: Area2D

var direction: float:
	get: return Input.get_axis("Left", "Right")

var coyote_timer := COYOTE_TIME
var jump_timer := JUMP_DURATION
var jump_reset := true

var items: Array[Item] = []

var is_on_coyote_floor: bool = false:
	get: return coyote_timer > 0.

signal first_jump  # emitted when first jumping, enables double jump

func evaluate_items():
	items = []
	for child: Node in get_children():
		if child is Item:
			items.append(child)

func _ready():
	sprite.play()
	Global.player = self
	evaluate_items()

func a_press(delta: float) -> void:
	var collisions := interaction_area.get_overlapping_areas()
	if len(collisions) > 0:
		for area in collisions:
			if area is Interactable:
				area.interact()
	else:
		jump(delta)


	for item: Item in items:
		if item.a_press(delta):
			break

func b_press(delta: float) -> void:
	for item: Item in items:
		if item.b_press(delta):
			break

# if the player can jump, then they will normal jump
# otherwise code will try to execute an item jump
func jump(delta: float) -> void:
	# # add horizontal velocity on jump
	# var direction: float = Input.get_axis("Left", "Right")
	# if direction > 0:
	# 	velocity.x = SPEED
	# elif direction < 0:
	# 	velocity.x = -SPEED

	# $JumpTimer.start()
	# sprite.animation = "jump"
	# sprite.play()

	if is_on_coyote_floor:
		# first_jump.emit()
		coyote_timer = 0
		# velocity.y = JUMP_VELOCITY
		jump_with_no_horizontal_velocity()
	else:
		for item: Item in items:
			print_debug(item)
			if item.jump(delta):
				break

func jump_with_horizontal_velocity() -> void:
	if direction > 0:
		velocity.x = SPEED
	elif direction < 0:
		velocity.x = -SPEED

	jump_with_no_horizontal_velocity()

func jump_with_no_horizontal_velocity() -> void:
	velocity.y = JUMP_VELOCITY

func _jump():  # _on_jump_timer_timeout
	jump_with_no_horizontal_velocity()

func accelerate(dir: float, delta: float) -> void:
	var acc := ACCELERATION if is_on_floor() else AERIAL_ACCELERATION
	velocity.x = move_toward(velocity.x, SPEED * dir, acc * delta)

func add_friction(delta: float) -> void:
	var friction := FRICTION if is_on_floor() else AIR_FRICTION
	velocity.x = move_toward(velocity.x, 0., friction * delta)

func _physics_process(delta: float) -> void:
	# Coyote Time Logic
	if is_on_floor() && coyote_timer < COYOTE_TIME:
		coyote_timer = COYOTE_TIME
	elif !is_on_floor() && coyote_timer > 0:
		coyote_timer = move_toward(coyote_timer, 0, delta)

	if !items.any(func(item): return item.override_gravity):  # Gravity
		velocity.y += Global.GRAVITY * delta

	if Input.is_action_just_pressed("A"):
		a_press(delta)
	elif Input.is_action_just_pressed("B"):
		b_press(delta)

	if Input.is_action_just_released("A"):
		jump_timer = JUMP_DURATION

	if direction:
		accelerate(direction, delta)
	else:
		add_friction(delta)

	move_and_slide()

	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true

func _process(_delta):
	var animation := ""

	for item in items:
		if item.animation:
			animation = item.animation
			break

	# base movement animation logic
	if !animation:
		if is_on_floor():
			if sprite.animation == "fall":  # just landed
				animation = "land"
			elif sprite.animation == "land" && sprite.is_playing():  # play the whole landing animation
				animation = "land"
			elif velocity.length():  # if walking
				animation = "walk"
			else:
				animation = "idle"  # if standing still
		else:
			if velocity.y < 0:
				animation = "rise"
			else:
				animation = "fall"

	if sprite.animation != animation:
		sprite.animation = animation
		sprite.play()

# func wall_jump(direction: int) -> void:
# 	velocity.x = JUMP_VELOCITY * direction
# 	velocity.y = JUMP_VELOCITY

