extends State

#I know this is awful but the stuff should be arranged this way anyway
@onready var npc : NPC = get_parent().get_parent()

func Enter() -> void:
	npc.animation_player.play("idle_r")
	pass
	
func Exit() -> void:
	pass
	
func Update(_delta: float) -> void:
	pass
	
func Physics_Update(_delta: float) -> void:
	pass
	
