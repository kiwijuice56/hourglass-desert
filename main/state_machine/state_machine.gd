class_name StateMachine
extends Node

@export var initial_state: State
@export var controller: Node
@export var state_label: Label

var active_state: State

func _ready() -> void:
	transition_to(initial_state.name)

func _physics_process(delta: float) -> void:
	active_state.physics_process(delta)

func _input(event: InputEvent) -> void:
	active_state.input(event)

func transition_to(state_name: String, data: Dictionary = {}) -> void:
	var to_state: State = get_node(state_name)
	
	# active_state is null when the state machine initializes
	if is_instance_valid(active_state):
		@warning_ignore("redundant_await")
		await active_state.exit(data)
	@warning_ignore("redundant_await")
	await to_state.enter(data)
	
	if is_instance_valid(state_label):
		state_label.text = state_name
	
	active_state = to_state
