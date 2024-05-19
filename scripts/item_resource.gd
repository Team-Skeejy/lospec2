class_name ItemResource
extends Resource

@export var texture : AtlasTexture
@export var name : String = ""
@export_multiline var description : String = ""
@export_file("*.tscn") var item_scene : String = "res://scenes/items/sample_item.tscn"
@export var cost : int
#@export var category : String 
