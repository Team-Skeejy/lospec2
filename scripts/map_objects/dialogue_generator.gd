extends Node2D


@export var speech_bubble_scene : PackedScene

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("A"):
		var speech_bubble : SpeechBubble = speech_bubble_scene.instantiate()
		add_child(speech_bubble)
		speech_bubble.init("wow I love this, it's so cool", "r")
