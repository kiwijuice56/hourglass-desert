class_name FogEffect
extends ColorRect

@onready var screen_size: Vector2 = get_viewport().size 

func _physics_process(_delta: float) -> void:
	material.set_shader_parameter("position", CommonReference.player.global_position / 256)
