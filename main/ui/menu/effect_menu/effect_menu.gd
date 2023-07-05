class_name EffectMenu
extends Menu

@export var transition_time: float = 0.3

@onready var selector: EffectSelector = $EffectSelector

func _ready() -> void:
	exit()

func enter() -> void:
	selector.initialize()
	modulate.a = 0.0
	super.enter()
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, transition_time)
	await tween.finished
	selector.set_process_input(true)

func exit() -> void:
	modulate.a = 1.0
	selector.set_process_input(false)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, transition_time)
	await tween.finished
	super.exit()
