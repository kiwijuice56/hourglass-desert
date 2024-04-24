class_name NpcWaddlingDirectional
extends NpcWaddling

@export var idle_animation_name: String

func enter(data: Dictionary = {}) -> void:
	var index: int = randi() % 4
	var direction: Vector2 = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT][index]
	var anim_suffix: String = "_" + ["up", "down", "left", "right"][index] 
	
	if npc.collision.is_colliding(direction):
		state_machine.transition_to(data.previous_state)
		return
	
	npc.anim.speed_scale = speed_multiplier
	npc.anim.play(waddle_animation_name + anim_suffix)
	
	npc.move(direction, waddle_time, speed_multiplier)
	await npc.moved
	
	npc.anim.play(idle_animation_name + anim_suffix)
	
	if CommonReference.main.current_world.mirrors:
		var bounding_box: Vector2 = CommonReference.main.current_world.bounding_box
		npc.global_position = npc.global_position.posmodv(bounding_box)
	
	state_machine.transition_to(data.previous_state)
