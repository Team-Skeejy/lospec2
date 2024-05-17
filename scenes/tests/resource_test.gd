extends Node2D


@export var item_resource : ItemResource

func _ready():
	var d : Dictionary = {
		NPCIdle : "1bsd",
		NPCWander : "12312"
	}
	print(d)
	print(d[NPCIdle])
