class_name ItemResource
extends Resource

@export var texture : AtlasTexture
@export var name : String = ""
@export_multiline var description : String = ""
@export_file("*.tscn") var behaviour_scene : String = "res://scenes/items/sample_item.tscn"
@export var cost : int
@export var for_sale : bool = true
@export var key_type : Lock.Type = Lock.Type.none
#@export var category : String 
