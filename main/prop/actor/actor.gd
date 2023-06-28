class_name Actor
extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var raycast: RayCast2D = $CollisionRayCast2D
@onready var area: Area2D = $DetectionArea2D
