class_name Player
extends Node2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var raycast: RayCast2D = $RayCast2D
@onready var bump_timer: Timer = $BumpTimer
@onready var step_player: StepStreamPlayer = $StepStreamPlayer
