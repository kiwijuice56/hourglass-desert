class_name JuliaFractalNavigation
extends ColorRect

@export var world_marker: Marker2D

func _process(_delta: float) -> void:
	var pos: Vector2 = CommonReference.player.position / world_marker.position
	material.set_shader_parameter("mouse_pos", 6 * pos - Vector2(3, 3))
