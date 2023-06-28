class_name NpcWaddle
extends State

@export var waddle_time: float
@export_range(1, 2) var speed_multiplier: int = 1
@export var waddle_timer: Timer

var npc: Actor

func _ready() -> void:
	npc = state_machine.controller as Actor

func enter(data: Dictionary = {}) -> void:
	var direction: Vector2 = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT].pick_random()
	npc.raycast.target_position = direction * 16
	npc.raycast.force_raycast_update()
	if npc.raycast.is_colliding():
		state_machine.transition_to(data.previous_state)
		return
	
	npc.anim.speed_scale = speed_multiplier
	npc.anim.play("waddle")
	
	for i in range(16.0 / speed_multiplier):
		waddle_timer.start(waddle_time / 16.0)
		await waddle_timer.timeout
		npc.global_position += speed_multiplier * direction
	
	state_machine.transition_to(data.previous_state)
