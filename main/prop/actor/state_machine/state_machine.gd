class_name StateMachine
extends Node

@export var controller: Actor
@export var initial_state: State
@export var state_label: Label

var active_state: State
var state_stack: Array[String]

func _ready() -> void:
	if initial_state == null:
		return
	transition_to(initial_state.name)

func _physics_process(delta: float) -> void:
	if active_state == null:
		return
	active_state.physics_process(delta)
	if is_instance_valid(active_state) and is_instance_valid(state_label) and state_label.visible:
		state_label.text = active_state.name

func _input(event: InputEvent) -> void:
	if active_state == null:
		return
	active_state.input(event)

func transition_to(state_name: String, data: Dictionary = {}) -> void:
	var to_state: State = get_node(state_name)
	
	# active_state is null when the state machine initializes
	if is_instance_valid(active_state):
		await active_state.exit(data)
		data.previous_state = active_state.name
	else:
		data.previous_state = ""
	active_state = to_state
	await to_state.enter(data)

func was_interrupted(state: State) -> bool:
	return state != active_state or controller.disabled
