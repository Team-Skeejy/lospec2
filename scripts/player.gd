class_name Player
extends CharacterBody2D

@export var sprite: AnimatedSprite2D
@export var interaction_area: Area2D

var speed := 8000.0
var jump_velocity := -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = Global.GRAVITY

signal first_jump

func a_press():
	var collisions := interaction_area.get_overlapping_areas()
	if len(collisions) > 0:
		for area in collisions:
			if area is Interactable:
				area.interact()
	elif is_on_floor():
		first_jump.emit()
		jump()

func _ready():
	sprite.play()
	

func _physics_process(delta: float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("A"):
		a_press()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")

	# set direction of player
	if direction:
		if direction > 0:
			sprite.scale.x = 1
		elif direction < 0:
			sprite.scale.x = -1

		velocity.x = direction * speed * delta
		sprite.animation = "walk"
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		sprite.animation = "idle"

	move_and_slide()
	
func jump():
	velocity.y = jump_velocity
