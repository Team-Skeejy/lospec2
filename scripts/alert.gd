class_name Alert
extends AnimatedSprite2D

@export_range(0, 1) var progress: float:
	get:
		return frame / float(sprite_frames.get_frame_count("default"))
	set(value):
		visible = value > 0
		frame = int(sprite_frames.get_frame_count("default") * value)
