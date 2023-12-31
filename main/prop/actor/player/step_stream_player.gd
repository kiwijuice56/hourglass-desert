class_name StepStreamPlayer
extends AudioStreamPlayer

@export var sounds: Array[Resource]

@onready var player: Player = get_parent()
@onready var main: Main = get_tree().get_root().get_node("Main")

func play_step(_direction: Vector2) -> void:
	var data: TileData = main.current_world.tilemap.get_cell_tile_data(0, 
	main.current_world.tilemap.local_to_map(player.global_position))
	
	var id: int = 0
	
	if data != null:
		id = data.get_custom_data("sound")
	
	if id >= len(sounds):
		return
	
	stream = sounds[id]
	play()
