class_name Notification
extends Control

static var DESPAWN_TIME_LONG := 5.
static var DESPAWN_TIME_SHORT := 1.
static var DEFAULT_DESPAWN_TIME = DESPAWN_TIME_SHORT

@export var label: Label
@export var despawn_timer: Timer
@export var item_texture: TextureRect

var despawn_time: float = 5.0
var tween_time: float = 1.0
var despawn_distance: float = 64

var darken_texture: bool = false

func _ready():
	#start_with_texture("wow i ama so happy that \rthis text can be seen", Vector2(32, 0), true)
	start_no_texture("Wowowowowowowowow")

func start_no_texture(text: String):
	item_texture.hide()
	label.text = text
	start()

func start_with_texture(text: String, texture: Texture, dark: bool):
	item_texture.show()
	label.text = " " + text
	item_texture.texture = texture
	if dark:
		item_texture.modulate = Color.BLACK
	start()

func start():
	position.y = -despawn_distance
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", position.y + despawn_distance, tween_time)
	tween.tween_callback(despawn_timer.start.bind(despawn_time))

func _on_timer_timeout():
	print(123)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", position.y - despawn_distance, tween_time)
	tween.tween_callback(queue_free)
