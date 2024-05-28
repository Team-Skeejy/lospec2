@tool
class_name MapItem
extends Interactable

@export var sprite : Sprite2D

@export var item_resource : ItemResource :
	set(v):
		item_resource = v
		sprite.texture = item_resource.texture
		
func _init():
	interaction_name = "Get"


func interact(_holder):
	Global.player.add_item(item_resource)
	Global.instance.new_notification_with_texture(item_resource.description, item_resource.texture, false)
	queue_free()
	
func _ready():
	if Global.instance.player.has_item(item_resource):
		queue_free()
