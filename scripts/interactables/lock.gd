class_name Lock
extends Node

@export var item_needed : ItemResource

func can_be_opened() -> bool:
	if not item_needed: 
		return true
	
	var has_item = Global.player.has_item(item_needed)
	
	if has_item:
		Global.instance.new_notification_with_texture(item_needed.unlocked_notification_text, item_needed.texture, false)
	else:
		Global.instance.new_notification_with_texture(item_needed.locked_notification_text, item_needed.texture, true)
		
	return has_item
	
