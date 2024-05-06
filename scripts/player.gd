class_name Player
extends CharacterBody2D

static var SPEED := 100.
static var ACCELERATION := 900.
static var AERIAL_ACCELERATION := 800.
static var FRICTION := 1600.
static var AIR_FRICTION := 1000.
static var JUMP_VELOCITY := -300.
static var COYOTE_TIME := 0.2


@export var sprite: AnimatedSprite2D
@export var interaction_area: Area2D

var coyote_timer := COYOTE_TIME

var is_on_coyote_floor: bool = false:
	get: return coyote_timer > 0.

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = Global.GRAVITY

signal first_jump  # emitted when first jumping, enables double jump

func _ready():
	sprite.play()
	Global.player = self

func a_press() -> void:
	var collisions := interaction_area.get_overlapping_areas()
	if len(collisions) > 0:
		for area in collisions:
			if area is Interactable:
				area.interact()
	elif is_on_coyote_floor:
		first_jump.emit()
		coyote_timer = 0
		jump()
		print('first_jump')


func b_press() -> void:
	pass

func jump() -> void:
	var direction: float = Input.get_axis("Left", "Right")
	#if direction > 0:
		#velocity.x = SPEED
	#elif direction < 0:
		#velocity.x = -SPEED
	sprite.animation = "jump"
	sprite.play()
	$JumpTimer.start()

func _jump(): # _on_jump_timer_timeout
	velocity.y = JUMP_VELOCITY

func accelerate(direction: float, delta: float) -> void:
	var acceleration := ACCELERATION if is_on_floor() else AERIAL_ACCELERATION
	velocity.x = move_toward(velocity.x, SPEED * direction, acceleration * delta)

func add_friction(delta: float) -> void:
	var friction := FRICTION if is_on_floor() else AIR_FRICTION
	velocity.x = move_toward(velocity.x, 0., friction * delta)

func _physics_process(delta: float) -> void:
	# Coyote Time Logic
	if is_on_floor() && coyote_timer < COYOTE_TIME:
		coyote_timer = COYOTE_TIME
	elif !is_on_floor() && coyote_timer > 0:
		coyote_timer = move_toward(coyote_timer, 0, delta)

	if not is_on_floor():  # Gravity
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("A"):
		a_press()
	elif Input.is_action_just_pressed("B"):
		b_press()

	var direction: float = Input.get_axis("Left", "Right")
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
	if is_on_floor():
		if velocity.length():
			sprite.animation = "walk" 
		elif sprite.animation != "jump":
			sprite.animation = "idle"
		elif sprite.animation == "jump" and not sprite.is_playing():
			sprite.animation = "land"
		sprite.play()
	
	
func wall_jump(direction: int) -> void:
	velocity.x = JUMP_VELOCITY * direction
	velocity.y = JUMP_VELOCITY
	
