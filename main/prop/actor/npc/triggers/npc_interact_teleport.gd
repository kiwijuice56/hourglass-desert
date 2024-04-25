class_name NpcInteractTeleport
extends NpcInteract

@export var interact_animation_name: String
@export var world: String
@export var anchor: String
@export_flags("up", "left", "down", "right") var allowed_direction: int = 15

var npc: Npc

func _ready() -> void:
	npc = controller as Npc
	await npc.ready
	npc.interact_detection.area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	var player: Player = area.get_parent()
	var idx: int = ["up", "left", "down", "right"].find(player.direction)
	if (allowed_direction >> idx) % 2 == 0:
		return
	
	CommonReference.player.disabled = true
	npc.anim.play(interact_animation_name)
	await npc.anim.animation_finished
	CommonReference.main.call_deferred("switch_world", world, anchor, 0)
