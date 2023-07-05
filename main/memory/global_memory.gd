extends Node
# Stores the currently loaded save data

var data: Dictionary

func reset_memory() -> void:
	data = {}
	data.time = Era.CURRENT
	data.unlocked_effects = [Player.Effect.NORMAL, Player.Effect.DUCKLING]
