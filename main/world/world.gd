class_name World
extends Node2D

@onready var anchors: Node = $Anchors
@onready var tilemap: TileMap = $FloorTileMap
@onready var bounding_box: Vector2 = $WorldSizeMarker.global_position
