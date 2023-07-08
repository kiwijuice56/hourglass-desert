class_name PlayerIdling
extends State

func physics_process(_delta: float) -> void:
	if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").length() != 0:
		state_machine.transition_to("PlayerWalking")
		return
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.transition_to("PlayerInteracting")
		return
	if Input.is_action_just_pressed("menu"):
		state_machine.transition_to("PlayerSelecting")
		return
