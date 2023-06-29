class_name PlayerIdling
extends State

func physics_process(_delta: float) -> void:
	interruptible = true
	
	if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").length() != 0:
		state_machine.transition_to("PlayerWalking")
