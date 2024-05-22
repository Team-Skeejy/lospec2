class_name ItemResource
extends Resource

enum Category {
	none,
	category1
}

@export var texture : AtlasTexture
@export var name : String = ""
@export_multiline var description : String = ""
@export_file("*.tscn") var behaviour_scene : String = "res://scenes/items/sample_item.tscn"
@export var cost : int
@export var for_sale : bool = true
@export var category : Category = Category.none
@export var key_type : Lock.Type = Lock.Type.key3
#@export var category : String 
