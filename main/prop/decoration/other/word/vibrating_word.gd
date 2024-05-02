class_name VibratingWord
extends RichTextLabel

func _ready() -> void:
	while true:
		var my_text: String = Array("abcdefghijklmnopqrstuvwxyz      ".split("")).pick_random()
		text = "[shake rate=8.0 level=6 connected=0]" + my_text + "[/shake]"
		await get_tree().create_timer(randf_range(0.5, 1.5)).timeout
