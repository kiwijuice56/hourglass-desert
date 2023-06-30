@tool
class_name FractalNavigation
extends ColorRect

@onready var cam: Camera3D = $Camera3D

func _ready() -> void:
	material.set_shader_parameter("cam_pos", cam.global_position)
	material.set_shader_parameter("cam_mat", cam.global_transform.basis)
	material.set_shader_parameter("width", size.x)
	material.set_shader_parameter("height", size.y)
