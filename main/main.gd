class_name Main
extends Node
# Handles world switching and initial game state

const WORLD_PATH: String = "res://main/world/"

@onready var canvas_mirror: CanvasMirror = $CanvasMirror

var current_world: World

func _ready() -> void:
	randomize()
	GlobalMemory.reset_memory()
	switch_world("Neon", "Default")

# world_name must match the name of a folder within WORLD_PATH
func switch_world(world_name: String, anchor_name: String) -> void:
	# Remove old world (does not exist at the start of the game)
	if is_instance_valid(current_world):
		remove_child(current_world)
		current_world.queue_free()
	
	# Load the given world scene
	var folder: String = WORLD_PATH + world_name.to_snake_case() + "/"
	var era: int = GlobalMemory.data.time
	# Look for a world scene in this time period or before
	for i in range(GlobalMemory.data.time, -1, -1):
		if DirAccess.dir_exists_absolute(folder + str(i) + "/"):
			folder += str(i) + "/"
			era = i
			break
	var path: String = folder + world_name.to_pascal_case() + str(era) + ".tscn"
	
	current_world = load(path).instantiate()
	add_child(current_world)
	move_child(current_world, 1)
	
	# Initialize mirroring if enabled by the world
	canvas_mirror.visible = current_world.mirrors
	if current_world.mirrors:
		canvas_mirror.mirror_world(CommonReference.player, current_world.bounding_box)
	
	# Set the player's position
	CommonReference.player.global_position = current_world.anchors.get_node(anchor_name).global_position
