class_name World
extends Node2D

@export var mirrors: bool = false
@export var camera_limit_left: int = -100000
@export var camera_limit_top: int = -100000
@export var camera_limit_right: int = 100000
@export var camera_limit_bottom: int = 100000


@onready var anchors: Node = $Anchors
@onready var tilemap: TileMap = $FloorTileMap
@onready var bounding_box: Vector2 = $WorldSizeMarker.global_position
