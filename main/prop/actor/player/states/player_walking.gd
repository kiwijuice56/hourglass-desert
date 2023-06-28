class_name PlayerWalking
extends State

const DIRECTION_MAP: Dictionary = {
	"up": Vector2.UP, 
	"left": Vector2.LEFT, 
	"down": Vector2.DOWN, 
	"right": Vector2.RIGHT 
}

@export_range(1, 2) var speed_multiplier: int = 1
@export var bump_timer: Timer
@export var walk_timer: Timer

var player: Player
var key_history: Array = []
var odd_step: bool = false

signal moved

func _ready() -> void:
	moved.connect(_on_moved)
	player = state_machine.controller as Player

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
	# Maintain key_history so that the last item is the most recently pressed direction
	for direction in DIRECTION_MAP.keys():
		if Input.is_action_just_pressed("ui_" + direction):
			key_history.append(direction)
	for i in range(len(key_history)):
		if i < len(key_history) and not Input.is_action_pressed("ui_" + key_history[i]):
			key_history.remove_at(i)
			i -= 1

func move(direction: String) -> void:
	# Detect walls and prevent movement
	player.raycast.target_position = DIRECTION_MAP[direction] * 16
	player.raycast.force_raycast_update()
	if player.raycast.is_colliding():
		player.anim.play("idle_" + direction) 
		# A small delay prevents infinite recursion when bumping
		bump_timer.start()
		await bump_timer.timeout
		moved.emit()
		return
	
	# Flip which foot is moving
	odd_step = not odd_step
	
	# Play walking audio
	player.step_player.play_step(DIRECTION_MAP[direction] * 16)
	
	# Play animation
	player.anim.speed_scale = speed_multiplier
	player.anim.play("walk_" + direction + ("_odd" if odd_step else "_even"))
	
	for i in range(16.0 / speed_multiplier):
		walk_timer.start(0.24 / 16.0)
		await walk_timer.timeout
		player.global_position += speed_multiplier * DIRECTION_MAP[direction]
	
	# Loop the player positiont to keep within the bounding box of a looping world
	if CommonReference.main.current_world.mirrors:
		var bounding_box: Vector2 = CommonReference.main.current_world.bounding_box
		player.global_position = player.global_position.posmodv(bounding_box)
	
	moved.emit()
