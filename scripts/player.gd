class_name Player
extends CharacterBody2D

enum EDirection {
	left, right
}

static var TERMINAL_VELOCITY := 900.

static var SPEED := 100.
static var ACCELERATION := 900.
static var AERIAL_ACCELERATION := 400.
static var FRICTION := 1600.
static var AIR_FRICTION := 1000.
static var JUMP_VELOCITY := -150.
static var COYOTE_TIME := 0.1
static var JUMP_DURATION := 0.2

@export var sprite_animation_player: AnimationPlayer
@export var interaction_area: Area2D
@export var inventory: Node

var direction: float:
	get: return Input.get_axis("Left", "Right")

var coyote_timer := COYOTE_TIME
var jump_timer := JUMP_DURATION
var is_default_jump := true
var jumping := false

# logical items
var items: Array[Item] = []

# is the player within the coyote grace period?
var is_on_coyote_floor: bool = false:
	get: return coyote_timer > 0.

# used to trigger exit function in interactables
var _prev_interact_target: Interactable
# current targeted interactable
var interact_target: Interactable

var _facing: EDirection = EDirection.right
var _animation := "idle"

# used to reevaluate items from player/inventory into the items list
# does not run removed from items already in the list
func evaluate_items():
	items = []
	for child: Node in inventory.get_children():
		if child is Item:
			add_item(child)

# # implemented, but don't use this, i think it's a bad idea
# func add_item_at(item: Item, index: int = 0):
# 	if item in items.filter(func(item): return !item.disabled): return

# 	if index == -1:
# 		items.push_front(item)
# 	elif index == 0 || index >= len(items):
# 		items.push_back(item)
# 	else:
# 		items.insert(index, item)
# 	inventory.add_child(item)

# reparents item to player/inventory
# adds item to item list
# runs item.added()
func add_item(item: Item):
	var parent := item.get_parent()
	if !parent:
		inventory.add_child(item)
	if parent != inventory:
		item.reparent(inventory)

	for i in range(len(items)):
		var itm: Item = items[i]
		if itm.priority >= item.priority:
			items.insert(i, item)
			item.added()
			return
		i += 1
	items.push_back(item)
	item.added()

# removes item from item list
# runs item.removed()
# DOES NOT reparent item
func remove_item(item: Item):
	var index := items.find(item)
	if index > -1:
		items.remove_at(index)
		item.removed()

func _ready():
	sprite_animation_player.play()
	Global.player = self
	evaluate_items()

# handles a press logic
func a_press(delta: float) -> void:
	if interact_target and is_on_floor():
		interact_target.interact()
	else:
		jumping = true

	for item: Item in items.filter(func(item): return !item.disabled): if item.a_press(delta): break

# handles b press logic
func b_press(delta: float) -> void:
	for item: Item in items.filter(func(item): return !item.disabled): if item.b_press(delta): break

# if the player can jump, then they will normal jump
# otherwise code will try to execute an item jump
func jump(delta: float) -> void:
	if is_on_coyote_floor || is_default_jump:
		is_default_jump = true
		coyote_timer = 0
		jump_with_no_horizontal_velocity()
	else:
		for item: Item in items.filter(func(item): return !item.disabled): if item.jump(delta): break

func jump_with_horizontal_velocity() -> void:
	if direction > 0:
		velocity.x = SPEED
	elif direction < 0:
		velocity.x = -SPEED

	jump_with_no_horizontal_velocity()

func jump_with_no_horizontal_velocity() -> void:
	velocity.y = JUMP_VELOCITY

# gravity calc for player
func add_gravity(delta: float):
	velocity.y += Global.GRAVITY * delta

# adds left right forces based on controls using arrow keys
func add_player_left_right(dir: float, delta: float) -> void:
	var acc := ACCELERATION if is_on_floor() else AERIAL_ACCELERATION
	velocity.x = move_toward(velocity.x, SPEED * dir, acc * delta)

# slows the player down in all situations
func add_friction(delta: float) -> void:
	var friction := FRICTION if is_on_floor() else AIR_FRICTION
	velocity.x = move_toward(velocity.x, 0., friction * delta)


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

	var default_physics := true
	for item: Item in items.filter(func(item): return !item.disabled):
		if item.physics_process(delta):
			default_physics = false
			break

	# if default physics operations have not been muted by items
	if default_physics:
		add_gravity(delta)
		if direction:
			add_player_left_right(direction, delta)
		else:
			add_friction(delta)

	# clamps player speed
	velocity = velocity.clamp(Vector2.ONE * -TERMINAL_VELOCITY, Vector2.ONE * TERMINAL_VELOCITY)
	move_and_slide()

# animation logic
func handle_animation():
	var animation := ""

	for item in items.filter(func(item): return !item.disabled):
		if item.animation:
			animation = item.animation
			break

	# base movement animation logic
	if !animation:
		if is_on_floor():
			if _animation == "fall":  # just landed
				animation = "land"
			elif _animation == "land" && sprite_animation_player.is_playing():  # play the whole landing animation
				animation = "land"
			elif velocity.length() and not is_on_wall():  # if walking
				animation = "walk"
			else:
				animation = "idle"  # if standing still
		else:
			if velocity.y < 0:
				animation = "rise"
			else:
				animation = "fall"

	if _animation != animation:
		sprite_animation_player.play(animation + ("_l" if _facing == EDirection.left else "_r"))
		_animation = animation

	var facing := _facing
	if velocity.x > 0:
		facing = EDirection.left
	elif velocity.x < 0:
		facing = EDirection.right

	if _facing != facing:
		var animation_position := sprite_animation_player.current_animation_position
		sprite_animation_player.animation = _animation + ("_l" if _facing == EDirection.left else "_r")
		sprite_animation_player.seek(animation_position)
		_facing = facing

func _process(_delta: float):
	var collisions := interaction_area.get_overlapping_areas()
	_prev_interact_target = interact_target
	interact_target = null

	for area in collisions:
		if area is Interactable:
			if _prev_interact_target != area:
				if _prev_interact_target: _prev_interact_target.exited_interact_area()
				area.entered_interact_area()
			interact_target = area
			break

	if !interact_target && _prev_interact_target:
		_prev_interact_target.exited_interact_area()


	handle_animation()
