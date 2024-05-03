class_name Player
extends CharacterBody2D

@export var sprite: AnimatedSprite2D
@export var interaction_area: Area2D

@export_category("stats")
@export var speed := 800.
@export var acceleration := 800.
@export var friction := 1600.
@export var air_friction := 1000.
@export var jump_velocity := -300.

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = Global.GRAVITY

signal first_jump  # emitted when first jumping, enables double jump

func _ready():
	sprite.play()

func _physics_process(delta: float) -> void:
	if not is_on_floor():  # Gravity
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("A"):
		a_press()
	elif Input.is_action_just_pressed("B"):
		b_press()

	var direction: float = Input.get_axis("Left", "Right")

	if direction:
		sprite.scale.x = int(direction)  # flip sprite based on direction
		accelerate(direction, delta)
		sprite.animation = "walk"
	else:
		add_friction(delta)
		sprite.animation = "idle"

	move_and_slide()

func accelerate(direction: float, delta: float) -> void:
	velocity.x = move_toward(velocity.x, speed * direction, acceleration * delta)

func add_friction(delta: float) -> void:
	if is_on_floor():  # floor friction
		velocity.x = move_toward(velocity.x, 0., friction * delta)
	else:  # air friction
		velocity.x = move_toward(velocity.x, 0., air_friction * delta)

func jump() -> void:
	velocity.y = jump_velocity

func a_press() -> void:
	var collisions := interaction_area.get_overlapping_areas()
	if len(collisions) > 0:
		for area in collisions:
			if area is Interactable:
				area.interact()
	elif is_on_floor():
		first_jump.emit()
		jump()

func b_press() -> void:
	pass
