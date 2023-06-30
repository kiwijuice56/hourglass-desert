class_name Player
extends Actor
# Root node for the player character
# Behavior is handled by the state machine

const DIRECTION_MAP: Dictionary = {
	"up": Vector2.UP, 
	"left": Vector2.LEFT, 
	"down": Vector2.DOWN, 
	"right": Vector2.RIGHT 
}

signal interacted

@onready var step_player: StepStreamPlayer = $StepStreamPlayer
@onready var interact_hitbox: Area2D = $InteractHitboxArea2D

var direction: String = "down"
