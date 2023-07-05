class_name CollisionDetector
extends Node2D
# Detects collisions with two rays on opposite ends of a sprite to increase accuracy

@onready var ray1: RayCast2D = $RayCast2D
@onready var ray2: RayCast2D = $RayCast2D2

func is_colliding(dir: Vector2, distance: float = 23.9) -> bool:
	var angle: float = Vector2(1, 0).angle_to(dir)
	rotation = angle
	ray1.target_position.x = distance
	ray2.target_position.x = distance
	ray1.force_raycast_update()
	ray2.force_raycast_update()
	return ray1.is_colliding() or ray2.is_colliding()
