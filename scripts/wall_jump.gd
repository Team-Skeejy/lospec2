class_name WallJump
extends Item


@onready var player: Player = get_parent()

func _physics_process(delta):
	if disabled:
		return
		
	if player.is_on_coyote_floor:
		return
	
	if not Input.is_action_just_pressed("A"):
		return
	

	if player.is_on_wall_only() and Input.is_action_pressed("Left"):
		player.wall_jump(-1)
		print("wall_jump")
	elif player.is_on_wall_only() and Input.is_action_pressed("Right"):
		player.wall_jump(1)
		print("wall_jump")
	
