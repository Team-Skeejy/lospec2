@tool
class_name SmallTextPanel
extends Control


@export_multiline var text : String = '' :
	set(v):
		text = v
		if label:
			label.text = text

@onready var label : Label = $PanelContainer/Label

func _ready():
	label.text = text

