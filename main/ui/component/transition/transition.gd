class_name Transition
extends Control

@onready var anim: AnimationPlayer = $AnimationPlayer

func trans_in(type: int = 0) -> void:
	anim.play(str(type) + "in")
	await anim.animation_finished

func trans_out(type: int = 0) -> void:
	anim.play(str(type) + "out")
	await anim.animation_finished
