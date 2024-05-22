class_name InformationManager
extends Node

static var instance : InformationManager
static var MAX_INFO_PER_COMPANY = 5
# key: name of company : String
# val: array of "buy" or "sell" " Array[String
var information_gathered : Dictionary = {}
var completed_companies : Array : 
	get:
		return information_gathered.keys().filter(func(x):return len(information_gathered[x]) >= MAX_INFO_PER_COMPANY )

enum Type {
	BUY,
	SELL
}

signal information_added(company: String, type: Type)

func _ready():
	instance = self

func add_info(company: String, type: Type):
	if company in completed_companies:
		return
		
	if company in information_gathered.keys():
		information_gathered[company].append(type)
	else:
		information_gathered[company] = [type]
		
	#print_debug(company + ": " + str(type) )
	information_added.emit(company, type)


func generate_sample_info():
	information_gathered = {}
	for _i in 3:
		var company = Global.all_companies.pick_random()
		information_gathered[company] = []
		for _j in MAX_INFO_PER_COMPANY:
			information_gathered[company].append([Type.BUY, Type.SELL].pick_random())
			