extends Node

static var GRAVITY := 980
var player : Player

var sell_dialogue : PackedStringArray
var buy_dialogue : PackedStringArray
var small_talk_dialogue : PackedStringArray

func _ready():
	# I do this in global because I don't want to open files everytime a new dialogue generator is created
	setup_dialogue()
	
func setup_dialogue(): 
	var sell_file_path = "res://assets/text/sell_dialogue.txt"
	var file_access : FileAccess = FileAccess.open(sell_file_path, FileAccess.READ)
	sell_dialogue = file_access.get_as_text().split("\n", false)

	var buy_file_path = "res://assets/text/buy_dialogue.txt"
	file_access = FileAccess.open(buy_file_path, FileAccess.READ)
	buy_dialogue = file_access.get_as_text().split("\n", false)
	
	var small_talk_file_path = "res://assets/text/small_talk_dialogue.txt"
	file_access = FileAccess.open(small_talk_file_path, FileAccess.READ)
	small_talk_dialogue = file_access.get_as_text().split("\n", false)
