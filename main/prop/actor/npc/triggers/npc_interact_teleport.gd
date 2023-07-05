class_name NpcInteractTeleport
extends NpcInteract

@export var sound_player: AudioStreamPlayer
@export var world: String
@export var anchor: String

var npc: Npc

func _ready() -> void:
	npc = controller as Npc
	await npc.ready
	npc.interact_detection.area_entered.connect(_on_area_entered)

func _on_area_entered(_area: Area2D) -> void:
	CommonReference.player.disabled = true
	npc.anim.play("npc_interact_teleport_trigger")
	await npc.anim.animation_finished
	CommonReference.main.call_deferred("switch_world", world, anchor, 0)
