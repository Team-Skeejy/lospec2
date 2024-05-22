class_name Lock
extends Node

enum Type {
	none,
	key1,
	key2
}

@export var key : Type = Type.none

var opened : bool :
	get:
		return Global.player.has_key(key)

func can_be_opened() -> bool:
	print_debug('can I be opened?')
	return Global.player.has_key(key)
	
