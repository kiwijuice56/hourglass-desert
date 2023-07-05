class_name PlayerWalking
extends State

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

func enter(_data: Dictionary = {}) -> void:
	remove_unpressed_keys()
	
	# Register key presses from before entering walking state
	for direction in player.DIRECTION_MAP.keys():
		if not direction in key_history and Input.is_action_pressed("ui_" + direction):
			key_history.append(direction)
	move(key_history.back())

func physics_process(_delta: float) -> void:
	# Maintain key_history so that the last item is the most recently pressed direction
	for direction in player.DIRECTION_MAP.keys():
		if Input.is_action_just_pressed("ui_" + direction):
			key_history.append(direction)
	remove_unpressed_keys()

func remove_unpressed_keys() -> void:
	for i in range(len(key_history)):
		if i < len(key_history) and not Input.is_action_pressed("ui_" + key_history[i]):
			key_history.remove_at(i)
			i -= 1

func move(direction: String) -> void:
	if state_machine.was_interrupted(self):
		state_machine.transition_to("PlayerIdling")
		return
	
	player.direction = direction
	
	# Detect walls and prevent movement
	if player.collision.is_colliding(player.DIRECTION_MAP[direction]):
		player.anim.play("idle_" + direction) 
		# A small delay prevents infinite recursion when bumping
		bump_timer.start()
		await bump_timer.timeout
		
		if state_machine.was_interrupted(self):
			state_machine.transition_to("PlayerIdling")
			return
		
		if Input.is_action_pressed("ui_accept"):
			state_machine.transition_to("PlayerInteracting")
			return
		
		moved.emit() 
		return
	
	# Flip which foot is moving
	odd_step = not odd_step
	
	# Play walking audio
	player.step_player.play_step(player.DIRECTION_MAP[direction] * 16)
	
	# Play animation
	player.anim.speed_scale = speed_multiplier
	player.anim.play("walk_" + direction + ("_odd" if odd_step else "_even"))
	
	# Move the player
	player.move(player.DIRECTION_MAP[direction], 0.24, speed_multiplier)
	await player.moved
	
	# Loop the player position to keep within the bounding box of a looping world
	if CommonReference.main.current_world.mirrors:
		var bounding_box: Vector2 = CommonReference.main.current_world.bounding_box
		player.global_position = player.global_position.posmodv(bounding_box)
	
	moved.emit()
