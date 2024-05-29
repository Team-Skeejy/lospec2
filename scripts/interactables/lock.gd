class_name Lock
extends Node

@export var item_needed : ItemResource

func _ready():
	if not get_parent().lock:		
		get_parent().lock = self

func can_be_opened(make_notification:bool = true) -> bool:
	if not item_needed: 
		return true
	
	var has_item = Global.player.has_item(item_needed)
	
	if not make_notification:
		return has_item
	
	if has_item:
		var text = item_needed.unlocked_notification_text
		if text:
			Global.instance.new_notification_with_texture(text, item_needed.texture, false)
	else:
		var text = item_needed.locked_notification_text
		if text:
			Global.instance.new_notification_with_texture(text, item_needed.texture, true)
		
	return has_item
	
