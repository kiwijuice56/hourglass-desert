class_name PlayerInteracting
extends State


var player: Player

func _ready() -> void:
	player = state_machine.controller as Player

func enter(_data: Dictionary = {}) -> void:
	player.raycast.target_position = player.DIRECTION_MAP[player.direction] * 23
	player.raycast.force_raycast_update()
	
	if player.raycast.is_colliding():
		player.anim.play("interact_" + player.direction)
		await player.interacted
		player.interact_hitbox.position = player.DIRECTION_MAP[player.direction] * 16
		player.interact_hitbox.get_child(0).disabled = false
		
		await player.anim.animation_finished
		if state_machine.was_interrupted(self):
			return
	state_machine.transition_to("PlayerIdling")

func exit(_data: Dictionary = {}) -> void:
	player.interact_hitbox.get_child(0).disabled = true
