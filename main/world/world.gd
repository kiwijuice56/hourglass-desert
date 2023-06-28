class_name World
extends Node2D

@export var mirrors: bool = false

@onready var anchors: Node = $Anchors
@onready var tilemap: TileMap = $FloorTileMap
@onready var bounding_box: Vector2 = $WorldSizeMarker.global_position
