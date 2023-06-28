class_name CanvasMirror
extends Node

@onready var screen_size: Vector2 = get_viewport().size / 2

func mirror_world(controller: Node2D, bounding_box: Vector2) -> void:
	for node in get_children():
		if node is SubViewport:
			node.world_2d = get_viewport().world_2d
			node.get_child(0).target = controller
		if node is MovementCopier:
			node.target = controller
	
	%LeftCamera.shift.x = bounding_box.x - screen_size.x / 2
	%LeftMirror.shift.x = -screen_size.x / 2
	
	%RightCamera.shift.x = screen_size.x / 2
	%RightMirror.shift.x = bounding_box.x + screen_size.x / 2
	
	%TopCamera.shift.y = bounding_box.y - screen_size.y / 2
	%TopMirror.shift.y = -screen_size.y / 2
	
	%BottomCamera.shift.y = screen_size.y / 2
	%BottomMirror.shift.y = bounding_box.y + screen_size.y / 2
	
	%TopLeftCamera.shift.x = bounding_box.x - screen_size.x / 2
	%TopLeftCamera.shift.y = bounding_box.y - screen_size.y / 2
	%TopLeftMirror.shift.x = -screen_size.x / 2
	%TopLeftMirror.shift.y = -screen_size.y / 2
	
	%TopRightCamera.shift.x = screen_size.x / 2
	%TopRightCamera.shift.y = bounding_box.y - screen_size.y / 2
	%TopRightMirror.shift.x = bounding_box.x + screen_size.x / 2
	%TopRightMirror.shift.y = -screen_size.y / 2
	
	%BottomLeftCamera.shift.x = bounding_box.x - screen_size.x / 2
	%BottomLeftCamera.shift.y = screen_size.y / 2
	%BottomLeftMirror.shift.x = -screen_size.x / 2
	%BottomLeftMirror.shift.y = bounding_box.y + screen_size.y / 2
	
	%BottomRightCamera.shift.x = screen_size.x / 2
	%BottomRightCamera.shift.y = screen_size.y / 2
	%BottomRightMirror.shift.x = bounding_box.x + screen_size.x / 2
	%BottomRightMirror.shift.y = bounding_box.y + screen_size.y / 2
