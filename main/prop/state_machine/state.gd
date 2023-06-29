class_name State
extends Node

@onready var state_machine: StateMachine = get_parent()

var interruptible: bool = false

func enter(_data: Dictionary = {}) -> void:
	pass

func exit(_data: Dictionary = {}) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func input(_event: InputEvent) -> void:
	pass
