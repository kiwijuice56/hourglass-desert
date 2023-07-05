class_name Npc
extends Actor

@onready var interact_detection: Area2D = $InteractDetectionArea2D

func disable() -> void:
	super.disable()
	interact_detection.call_deferred("set", "disabled", true)

func enable() -> void:
	super.enable()
	interact_detection.call_deferred("set", "disabled", true)
