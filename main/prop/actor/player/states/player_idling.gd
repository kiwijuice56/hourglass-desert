class_name PlayerIdling
extends State

func physics_process(_delta: float) -> void:
	var dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if dir.length() != 0:
		state_machine.transition_to("PlayerWalking")
		return
	
	# TODO: idling animations and triggers can go here
