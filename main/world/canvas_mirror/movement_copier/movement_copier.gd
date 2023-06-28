class_name MovementCopier
extends Node2D
# Copies one node's position onto anothers every frame, used mainly for canvas mirroring

@export var target: Node2D
@export var shift: Vector2
@export var copy_x: bool = true
@export var copy_y: bool = true
@export var bounding_box: Vector2

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(target):
		return
	
	global_position = Vector2()
	if copy_x:
		global_position.x = target.global_position.x
	if copy_y:
		global_position.y = target.global_position.y
	global_position += shift
