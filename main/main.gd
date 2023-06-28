class_name Main
extends Node

const WORLD_PATH: String = "res://main/world/"

@onready var player: Player = $Player
@onready var canvas_mirror: CanvasMirror = $CanvasMirror

var current_world: World

func _ready() -> void:
	GlobalMemory.reset_memory()
	switch_world("Debug", "Default")

func switch_world(world_name: String, anchor_name: String) -> void:
	if is_instance_valid(current_world):
		remove_child(current_world)
		current_world.queue_free()
	var folder: String = WORLD_PATH + world_name.to_snake_case() + "/"
	var era: int = GlobalMemory.data.time
	
	# Look for a world in this era or before it
	for i in range(GlobalMemory.data.time, -1, -1):
		if DirAccess.dir_exists_absolute(folder + str(i) + "/"):
			folder += str(i) + "/"
			era = i
			break
	var path: String = folder + world_name.to_pascal_case() + str(era) + ".tscn"
	current_world = load(path).instantiate()
	add_child(current_world)
	move_child(current_world, 1)
	canvas_mirror.mirror_world(player, current_world.bounding_box)
	
	
	player.global_position = current_world.anchors.get_node(anchor_name).global_position
