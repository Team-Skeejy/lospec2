extends Node2D
@export var tutorial_only: bool

# spawns the player on scene start, and reparents player to the parent of player_spawner
func _ready():
	if tutorial_only && Global.is_tutorial() || !tutorial_only && !Global.is_tutorial():
		Global.instance.spawn_player(get_parent(), self)

