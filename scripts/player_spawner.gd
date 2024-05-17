extends Node2D

# spawns the player on scene start, and reparents player to the parent of player_spawner
func _ready():
	Global.instance.spawn_player(get_parent(), self)
