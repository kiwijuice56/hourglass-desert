class_name EffectMenu
extends Menu

@export var transition_time: float = 0.3

@onready var selector: EffectSelector = $EffectSelector

func _ready() -> void:
	modulate.a = 0.0
	selector.set_process_input(false)

func enter() -> void:
	$OpenPlayer.play()
	selector.initialize()
	modulate.a = 0.0
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, transition_time)
	await tween.finished
	super.enter()
	selector.prompt()

func exit() -> void:
	$ClosePlayer.play()
	modulate.a = 1.0
	selector.set_process_input(false)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, transition_time)
	await tween.finished
	super.exit()
