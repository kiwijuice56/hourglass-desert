class_name Actor
extends Node2D
# Base class for all dynamic/interactable props, such as doors and characters

signal moved

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionDetector = $CollisionDetector
@onready var hitbox: Area2D = $HitboxArea2D

@onready var movement_timer: Timer = $MovementTimer

var disabled: bool:
	set(val):
		disabled = val
		if disabled:
			disable()
		else:
			enable()

func _ready() -> void:
	await get_tree().get_root().ready
	CommonReference.main.disabled.connect(disable)
	CommonReference.main.enabled.connect(enable)

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
