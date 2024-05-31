class_name InformationUI
extends Control

@export var row_container : VBoxContainer
@export var row_scene : PackedScene

var full_rows : Dictionary = {} # key: company, value: InformationUIRow
var max_rows := 15
var empty_rows : Array[InformationUIRow] = []

var expanded: bool = false
var expansion_tween : Tween
var tween_duration : float = 0.5
var retracted_size := Vector2(160, 29)
var expanded_size := Vector2(160, 189)


func _ready():
	InformationManager.instance.information_added.connect(on_info_added)
	InformationManager.instance.company_removed.connect(on_company_removed)
	day_start() # TODO remove and call elsewhere

func day_start():
	full_rows = {}
	empty_rows = []
	for c in row_container.get_children():
		c.queue_free()
		
	for _i in max_rows:
		var row : InformationUIRow = row_scene.instantiate()
		row_container.add_child(row)
		empty_rows.append(row)

func on_info_added(company: String, type: InformationManager.Type):
	var row : InformationUIRow
	if company not in full_rows.keys():
		row = empty_rows.pop_back()
		row.set_company(company)
		full_rows[company] = row
	else:
		row = full_rows[company]
	
	if type == InformationManager.Type.BUY:
		row.add_buy_info()
	if type == InformationManager.Type.SELL:
		row.add_sell_info()
	
	row_container.move_child(row, 0)

func on_company_removed(company: String):
	if company in full_rows.keys():
		var row = full_rows[company]
		full_rows.erase(company)
		row.reset()
		row_container.move_child(row, max_rows - 1)


func flip_expanded():
	if expanded:
		retract()
	else:
		expand()

func expand():
	if expansion_tween and expansion_tween.is_running():
		expansion_tween.kill()  
	
	expanded = true
	expansion_tween = get_tree().create_tween()
	expansion_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	expansion_tween.tween_property(self, "size", expanded_size, tween_duration)
	await expansion_tween.finished
	print('done')
	
	
func retract():
	if expansion_tween and expansion_tween.is_running():
		expansion_tween.kill()
	
	expanded = false
	expansion_tween = get_tree().create_tween()
	expansion_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	expansion_tween.tween_property(self, "size", retracted_size, tween_duration)
