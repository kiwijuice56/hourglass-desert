class_name NpcWaddling
extends State

@export var waddle_animation_name: String = "waddle"
@export var waddle_time: float
@export_range(1, 2) var speed_multiplier: int = 1

var npc: Npc

func _ready() -> void:
	npc = state_machine.controller as Npc

func enter(data: Dictionary = {}) -> void:
	var direction: Vector2 = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT].pick_random()
	
	if npc.collision.is_colliding(direction):
		state_machine.transition_to(data.previous_state)
		return
	
	npc.anim.speed_scale = speed_multiplier
	npc.anim.play(waddle_animation_name)
	
	npc.move(direction, waddle_time, speed_multiplier)
	await npc.moved
	
	if CommonReference.main.current_world.mirrors:
		var bounding_box: Vector2 = CommonReference.main.current_world.bounding_box
		npc.global_position = npc.global_position.posmodv(bounding_box)
	
	state_machine.transition_to(data.previous_state)
