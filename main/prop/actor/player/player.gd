class_name Player
extends Actor
# Root node for the player character
# Behavior is handled by the state machine

@onready var step_player: StepStreamPlayer = $StepStreamPlayer
