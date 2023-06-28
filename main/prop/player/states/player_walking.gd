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
	key_history.clear()
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
	# Detect walls and prevent movement
	player.raycast.target_position = DIRECTION_MAP[direction] * 16
	player.raycast.force_raycast_update()
	if player.raycast.is_colliding():
		player.anim.play("idle_" + direction) 
		# A small delay prevents infinite recursion
		player.bump_timer.start()
		await player.bump_timer.timeout
		moved.emit()
		return
	
	# Flip which foot is moving
	odd_step = not odd_step
	
	# Play walking audio
	player.step_player.play_step()
	
	player.anim.speed_scale = speed_multiplier
	player.anim.play("walk_" + direction + ("_odd" if odd_step else "_even"))
	
	for i in range(16 / speed_multiplier):
		player.walk_timer.start(0.26 / 16.0)
		await player.walk_timer.timeout
		player.global_position += speed_multiplier * DIRECTION_MAP[direction]
	var bounding_box: Vector2 = player.main.current_world.bounding_box
	player.global_position = player.global_position.posmodv(bounding_box)
	
	moved.emit()
