class_name Player
extends Node2D

@onready var main: Main = get_tree().get_root().get_node("Main")
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var raycast: RayCast2D = $RayCast2D
@onready var bump_timer: Timer = $BumpTimer
@onready var walk_timer: Timer = $WalkTimer
@onready var step_player: StepStreamPlayer = $StepStreamPlayer
