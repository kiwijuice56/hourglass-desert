class_name PlayerInteracting
extends State

var player: Player

func _ready() -> void:
	player = state_machine.controller as Player

func enter(_data: Dictionary = {}) -> void:
	if player.disabled:
		state_machine.transition_to("PlayerIdling")
		return
	
	if player.collision.is_colliding(player.DIRECTION_MAP[player.direction]):
		var anim_name: String = "interact_%s_%s" % [player.direction, player.EFFECT_MAP[player.effect]]
		if not player.anim.has_animation(anim_name):
			anim_name = "interact_%s_normal" % [player.direction]
		player.anim.play(anim_name)
		
		await player.interacted
		if state_machine.was_interrupted(self):
			state_machine.transition_to("PlayerIdling")
			return
		player.interact_hitbox.position = player.DIRECTION_MAP[player.direction] * 16
		player.interact_hitbox.get_child(0).disabled = false
		
		await player.anim.animation_finished
	state_machine.transition_to("PlayerIdling")

func exit(_data: Dictionary = {}) -> void:
	player.interact_hitbox.get_child(0).disabled = true
