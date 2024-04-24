class_name PlayerSelecting
extends State

var player: Player

func _ready() -> void:
	player = state_machine.controller as Player

func enter(_data: Dictionary = {}) -> void:
	CommonReference.main.disable_all_actors()
	await CommonReference.ui.effect_menu.enter()
	var new_effect: Player.Effect = await CommonReference.ui.effect_menu.selector.selected
	await CommonReference.ui.effect_menu.exit()
	if new_effect == player.effect:
		pass
	else:
		await player.switch_effect(new_effect)
	CommonReference.main.enable_all_actors()
	state_machine.transition_to.call_deferred("PlayerIdling")
