class_name Main
extends Node
# Handles world switching, initial game state, and top-level world control

const WORLD_PATH: String = "res://main/world/"

@onready var canvas_mirror: CanvasMirror = $CanvasMirror

var current_world: World

signal disabled
signal enabled

func _ready() -> void:
	randomize()
	get_window().position = Vector2(32, 32)
	GlobalMemory.reset_memory()
	switch_world("Factory", "Default")

# world_name must match the name of a folder within WORLD_PATH
func switch_world(world_name: String, anchor_name: String, transition: int = -1) -> void:
	disable_all_actors()
	if transition != -1:
		await CommonReference.transition.trans_in(transition)
	
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
	
	# Set camera limits
	CommonReference.player.camera.limit_left = current_world.camera_limit_left
	CommonReference.player.camera.limit_top = current_world.camera_limit_top
	CommonReference.player.camera.limit_right = current_world.camera_limit_right
	CommonReference.player.camera.limit_bottom = current_world.camera_limit_bottom
	
	# Set the player's position
	CommonReference.player.global_position = current_world.anchors.get_node(anchor_name).global_position
	if transition != -1:
		await CommonReference.transition.trans_out(transition)
	enable_all_actors()

func disable_all_actors() -> void:
	disabled.emit()

func enable_all_actors() -> void:
	enabled.emit()
