class_name UI
extends CanvasLayer
# Root UI node, stores references to commonly accessed menus  

@onready var effect_menu: EffectMenu = $EffectMenu


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen", false):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
