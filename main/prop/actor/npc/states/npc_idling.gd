class_name NpcIdling
extends State

@export var transition_candidates: Array[String]
@export var idle_time: float = 3.0
@export var idle_time_range: float = 0.5
@export var idle_timer: Timer

func enter(_data: Dictionary = {}) -> void:
	idle_timer.start(idle_time + randf() * idle_time_range - idle_time_range / 2.0)
	await idle_timer.timeout
	state_machine.transition_to(transition_candidates.pick_random())
