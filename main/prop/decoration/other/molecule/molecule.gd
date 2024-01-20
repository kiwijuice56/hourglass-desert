class_name Molecule
extends Node3D

@export var speed_median: float = 8.0
@export var speed_rand: float = 4.0

@export var max_x: float = 2
@export var min_x: float = -2
@export var min_y: float = 0
@export var max_y: float = 2
@export var min_z: float = -2
@export var max_z: float = 0

var speed: float
var dir: Vector3 

func _ready() -> void:
	speed = speed + (randf() - 0.5) * 2.0 * speed_rand
	dir = Vector3(randf() - 0.5, randf() - 0.5, randf() - 0.5).normalized()
	var mol: int = randi() % get_child_count()
	var to_kill: Array[MeshInstance3D] = []
	for i in range(get_child_count()):
		if i != mol:
			to_kill.append(get_child(i))
	for child in to_kill:
		child.queue_free()

func _process(delta: float) -> void:
	position += speed * dir * delta
	
	get_child(0).look_at(dir)
	
	if position.x > max_x:
		dir = dir.bounce(Vector3(-1, 0, 0))
	if position.x < min_x:
		dir = dir.bounce(Vector3(1, 0, 0))
	if position.y > max_y:
		dir = dir.bounce(Vector3(0, -1, 0))
	if position.y <= min_y:
		position.y += 0.01
		dir = dir.bounce(Vector3(0, 1, 0))
	if position.z > max_z:
		dir = dir.bounce(Vector3(0, 0, -1))
	if position.z < min_z:
		dir = dir.bounce(Vector3(0, 0, 1))
