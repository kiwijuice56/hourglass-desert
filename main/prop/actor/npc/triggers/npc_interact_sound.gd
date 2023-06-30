class_name NpcInteractSound
extends Trigger

@export var sound_player: AudioStreamPlayer

var npc: Npc

func _ready() -> void:
	npc = controller as Npc
	await npc.ready
	npc.interact_detection.area_entered.connect(_on_area_entered)

func _on_area_entered(_area: Area2D) -> void:
	sound_player.play()
