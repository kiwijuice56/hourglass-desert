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

# Enum -> String is useful when loading animations and sprites
const EFFECT_MAP: Dictionary = {
	Effect.NORMAL: "normal",
	Effect.DUCKLING: "duckling"
}

const SPRITE_DIR: String = "res://main/prop/actor/player/sprites/"

enum Effect {
	NORMAL, DUCKLING
}

signal interacted

@onready var step_player: StepStreamPlayer = $StepStreamPlayer
@onready var interact_hitbox: Area2D = $InteractHitboxArea2D

var direction: String = "down"
var effect: Effect = Effect.DUCKLING

func disable() -> void:
	super.disable()
	interact_hitbox.call_deferred("set", "disabled", true)

func enable() -> void:
	super.enable()
