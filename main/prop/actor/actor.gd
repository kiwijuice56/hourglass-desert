class_name Actor
extends Node2D
# Base class for all dynamic/interactable props, such as doors and characters

signal moved

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionDetector = $CollisionDetector
@onready var hitbox: Area2D = $HitboxArea2D

@onready var movement_timer: Timer = $MovementTimer

# A disabled actor is intended to be uninteractable and unchangeable, although
# their state may still change. In order to prevent glitches while keeping code complexity
# low, the disable/enable methods will prevent any form of interactions by disabling nodes
# that allow states to influence thier controllers. States should still check if they
# are disabled with the was_interrupted method 
var disabled: bool:
	set(val):
		disabled = val
		if disabled:
			disable()
		else:
			enable()

func disable() -> void:
	hitbox.get_child(0).call_deferred("set", "disabled", true)
	movement_timer.paused = true

func enable() -> void:
	hitbox.get_child(0).call_deferred("set", "disabled", false)
	movement_timer.paused = false

# Moves this actor by 16 pixels, pixel-by-pixel to prevent jitter
func move(dir: Vector2, time: float = 0.24, speed_multiplier: int = 1) -> void:
	for i in range(16.0 / speed_multiplier):
		# 0.24 is a magic number for player speed, and 16 is how many pixels in a tile
		movement_timer.start(time / 16.0)
		await movement_timer.timeout
		global_position += speed_multiplier * dir
	moved.emit()
