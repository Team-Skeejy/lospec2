class_name Humanoid
extends CharacterBody2D

static var TERMINAL_VELOCITY := 900.

static var SPEED := 50. # this probably should not be a static since 
						# we most likely want npcs to move at a 
						# different speed from the player 
static var ACCELERATION := 900.
static var AERIAL_ACCELERATION := 400.
static var FRICTION := 1600.
static var AIR_FRICTION := 1000.
static var JUMP_VELOCITY := -150.
static var JUMP_DURATION := 0.2

var jump_timer := JUMP_DURATION
var is_default_jump := true
var jumping := false

var direction := 0.

@export var sprite_animation_player: AnimationPlayer
@export var interaction_area: Area2D
@export var inventory: Node

enum EDirection {
	left, right
}

# logical items
var items: Array[Item] = []

var _facing: EDirection = EDirection.right
var _animation := "idle"
var animation_name: String:
	get: return _animation + ("_l" if _facing == EDirection.left else "_r")

# used to trigger exit function in interactables
var _prev_interact_target: Interactable
# current targeted interactable
var interact_target: Interactable

# used to reevaluate items from player/inventory into the items list
# does not run removed from items already in the list
func evaluate_items():
	items = []
	for child: Node in inventory.get_children():
		if child is Item:
			add_item(child)

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
			item.added(self)
			return
		i += 1
	items.push_back(item)
	item.added(self)

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

# removes item from item list
# runs item.removed()
# DOES NOT reparent item
func remove_item(item: Item):
	var index := items.find(item)
	if index > -1:
		items.remove_at(index)
		item.removed()

func _ready():
	sprite_animation_player.play(animation_name)
	evaluate_items()

# adds left right forces based on controls using arrow keys
func add_left_right(dir: float, delta: float) -> void:
	var acc := ACCELERATION if is_on_floor() else AERIAL_ACCELERATION
	velocity.x = move_toward(velocity.x, SPEED * dir, acc * delta)

# gravity calc for player
func add_gravity(delta: float):
	velocity.y += Global.GRAVITY * delta

# slows the player down in all situations
func add_friction(delta: float) -> void:
	var friction := FRICTION if is_on_floor() else AIR_FRICTION
	velocity.x = move_toward(velocity.x, 0., friction * delta)

func evaluate_item_physics(delta: float):
	var default_physics := true
	for item: Item in items.filter(func(item): return !item.disabled):
		if item.physics_process(delta):
			default_physics = false
			break
	return default_physics

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
		_animation = animation
		sprite_animation_player.play(animation_name)

	var facing := _facing
	if velocity.x > 0:
		facing = EDirection.right
	elif velocity.x < 0:
		facing = EDirection.left

	if _facing != facing:
		_facing = facing
		sprite_animation_player.current_animation = animation_name

func _physics_process(delta: float):
	# if default physics operations have not been muted by items
	if evaluate_item_physics(delta):
		add_gravity(delta)
		if direction:
			add_left_right(direction, delta)
		else:
			add_friction(delta)

	# clamps player speed
	velocity = velocity.clamp(Vector2.ONE * -TERMINAL_VELOCITY, Vector2.ONE * TERMINAL_VELOCITY)
	move_and_slide()

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
