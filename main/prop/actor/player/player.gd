class_name Player
extends Actor
# Root node for the player character
# Behavior is handled by the state machine

# For convenience and clarity, some code and assets use strings to represent 
# directions and effects

# String -> Vector2 is useful when processing input events
const DIRECTION_MAP: Dictionary = {
	"up": Vector2.UP, 
	"left": Vector2.LEFT, 
	"down": Vector2.DOWN, 
	"right": Vector2.RIGHT 
}

# Enum -> String is useful when determing what animations should be played 
const EFFECT_MAP: Dictionary = {
	Effect.NORMAL: "normal",
	Effect.DUCKLING: "duckling"
}

enum Effect {
	NORMAL, DUCKLING
}

signal interacted

@onready var step_player: StepStreamPlayer = $StepStreamPlayer
@onready var interact_hitbox: Area2D = $InteractHitboxArea2D

var direction: String = "down"
var effect: Effect = Effect.DUCKLING
var frozen: bool = false
