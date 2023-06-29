class_name NpcWaddle
extends State

@export var waddle_time: float
@export_range(1, 2) var speed_multiplier: int = 1
@export var waddle_timer: Timer

var npc: Actor
var pause_movement: bool = false

func _ready() -> void:
	npc = state_machine.controller as Actor

func enter(data: Dictionary = {}) -> void:
	pause_movement = false
	
	var direction: Vector2 = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT].pick_random()
	
	# 23 is one less pixel than a tile and a half
	npc.raycast.target_position = direction * 23
	npc.raycast.force_raycast_update()
	if npc.raycast.is_colliding():
		state_machine.transition_to(data.previous_state)
		return
	
	npc.anim.speed_scale = speed_multiplier
	npc.anim.play("waddle")
	
	for i in range(16.0 / speed_multiplier):
		if pause_movement:
			return
		
		waddle_timer.start(waddle_time / 16.0)
		await waddle_timer.timeout
		npc.global_position += speed_multiplier * direction
	state_machine.transition_to(data.previous_state)

func exit(_data: Dictionary = {}) -> void:
	pause_movement = true
