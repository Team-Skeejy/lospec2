class_name Lock
extends Node

enum Type {
	none,
	key1,
	key2,
	key3
}

@export var key : Type = Type.none

func can_be_opened() -> bool:
	if key == Type.none: 
		return true
	
	return Global.player.has_key(key)
	
