class_name NPCWander
extends NPCState

static var MIN_DIST = 90
static var MAX_DIST = 100

func Enter() -> void:
	npc.destination = random_destination()
	if not npc.on_arrival.is_connected(_on_arrival):
		npc.on_arrival.connect(_on_arrival)
		
	
func _on_arrival():
	npc.on_arrival.disconnect(_on_arrival)
	transitioned.emit(self, "NPCIdle")

func Exit() -> void:
	if npc.on_arrival.is_connected(_on_arrival):
		npc.on_arrival.disconnect(_on_arrival)
	
func Update(_delta: float) -> void:
	pass

func random_destination() -> Vector2:
	var _dir : int = ((randi() % 2) * 2) - 1 # random between -1 and 1
	var _dist : float = randf_range(MIN_DIST, MAX_DIST)
	var dest_x : float = npc.global_position.x + (_dir * _dist)
	var dest_y : float = npc.global_position.y
	return Vector2(dest_x, dest_y)
	

