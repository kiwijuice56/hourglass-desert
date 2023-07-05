class_name FpsLabel
extends Label

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_on_update_timeout)

func _on_update_timeout() -> void:
	text = "fps: " + str(Engine.get_frames_per_second())
