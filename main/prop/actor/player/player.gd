class_name Player
extends Actor
# Root node for the player character
# Behavior is handled by the state machine

@onready var bump_timer: Timer = $BumpTimer
@onready var walk_timer: Timer = $WalkTimer
@onready var step_player: StepStreamPlayer = $StepStreamPlayer
