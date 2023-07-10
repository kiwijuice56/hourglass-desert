class_name Npc
extends Actor
# Base class for all non-player actors that can be interacted with
# The naming is unconventional ... doors are technically NPCs? It works

@onready var interact_detection: Area2D = $InteractDetectionArea2D

func disable() -> void:
	super.disable()
	interact_detection.call_deferred("set", "disabled", true)

func enable() -> void:
	super.enable()
	interact_detection.call_deferred("set", "disabled", true)
