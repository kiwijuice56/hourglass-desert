extends Node
# Stores the currently loaded save data

var data: Dictionary

func reset_memory() -> void:
	data = {}
	data.time = Era.CURRENT
