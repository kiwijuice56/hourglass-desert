class_name Player
extends Node2D
# Root node for the player character
# Behavior is handled by the state machine

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var raycast: RayCast2D = $RayCast2D
@onready var bump_timer: Timer = $BumpTimer
@onready var walk_timer: Timer = $WalkTimer
@onready var step_player: StepStreamPlayer = $StepStreamPlayer
