class_name PlayerWalking
extends State

const DIRECTION_MAP: Dictionary = {
	"up": Vector2.UP, 
	"left": Vector2.LEFT, 
	"down": Vector2.DOWN, 
	"right": Vector2.RIGHT 
}

@export_range(1, 2) var speed_multiplier: int = 1

var key_history: Array = []
var odd_step: bool = false

signal moved

func _ready() -> void:
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
	CommonReference.player.raycast.target_position = DIRECTION_MAP[direction] * 16
	CommonReference.player.raycast.force_raycast_update()
	if CommonReference.player.raycast.is_colliding():
		CommonReference.player.anim.play("idle_" + direction) 
		# A small delay prevents infinite recursion when bumping
		CommonReference.player.bump_timer.start()
		await CommonReference.player.bump_timer.timeout
		moved.emit()
		return
	
	# Flip which foot is moving
	odd_step = not odd_step
	
	# Play walking audio
	CommonReference.player.step_player.play_step()
	
	# Play animation
	CommonReference.player.anim.speed_scale = speed_multiplier
	CommonReference.player.anim.play("walk_" + direction + ("_odd" if odd_step else "_even"))
	
	for i in range(16.0 / speed_multiplier):
		CommonReference.player.walk_timer.start(0.24 / 16.0)
		await CommonReference.player.walk_timer.timeout
		CommonReference.player.global_position += speed_multiplier * DIRECTION_MAP[direction]
	
	# Loop the player positiont to keep within the bounding box of a looping world
	if CommonReference.main.current_world.mirrors:
		var bounding_box: Vector2 = CommonReference.main.current_world.bounding_box
		CommonReference.player.global_position = CommonReference.player.global_position.posmodv(bounding_box)
	
	moved.emit()
