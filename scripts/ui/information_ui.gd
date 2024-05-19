class_name InformationUI
extends Control

var rows : Dictionary = {}
@export var row_container : VBoxContainer
@export var row_scene : PackedScene

func _ready():
	InformationManager.instance.information_added.connect(on_info_added)

func day_start():
	rows = {}
	for c in row_container.get_children():
		c.queue_free()

func on_info_added(company: String, type: InformationManager.Type):
	var row : InformationUIRow
	if company not in rows.keys():
		row = row_scene.instantiate()
		row.set_company(company)
		row_container.add_child(row)
		rows[company] = row
	else:
		row = rows[company]
	
	if type == InformationManager.Type.BUY:
		row.add_buy_info()
	if type == InformationManager.Type.SELL:
		row.add_sell_info()
	
	row_container.move_child(row, 0)
