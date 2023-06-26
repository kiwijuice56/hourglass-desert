class_name PlayerWalking
extends State

const DIRECTION_MAP: Dictionary = {
	"up": Vector2.UP, "left": Vector2.LEFT, "down": Vector2.DOWN, "right": Vector2.RIGHT 
}

@export var speed_multiplier: float = 1.0

var player: Player
var key_history: Array = []
var odd_step: bool = false

signal moved

func _ready() -> void:
	player = state_machine.controller as Player
	moved.connect(_on_moved)

func _on_moved() -> void:
	if key_history.is_empty():
		state_machine.transition_to("PlayerIdling")
	else:
		move(key_history.back())

func enter(_data: Dictionary = {}):
	# Register key presses from before entering walking state
	for direction in DIRECTION_MAP.keys():
		if Input.is_action_pressed("ui_" + direction):
			key_history.append(direction)
	move(key_history.back())

func physics_process(_delta: float) -> void:
	for direction in DIRECTION_MAP.keys():
		if Input.is_action_just_pressed("ui_" + direction):
			key_history.append(direction)
		if Input.is_action_just_released("ui_" + direction):
			key_history.remove_at(key_history.find(direction))

func move(direction: String) -> void:
	odd_step = not odd_step
	
	player.anim.speed_scale = speed_multiplier
	player.anim.play("walk_" + direction + ("_odd" if odd_step else "_even"))
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(player, "global_position", 
	player.global_position + DIRECTION_MAP[direction] * 16, 0.24 * (1.0 / speed_multiplier))
	await tween.finished
	
	moved.emit()
