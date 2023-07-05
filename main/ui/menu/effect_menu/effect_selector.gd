class_name EffectSelector
extends HBoxContainer

const ICON_DIR: String = "res://main/ui/effect_menu/icons/"
const ICON_SIZE: int = 38
const OFFSET: int = 139

@export var shift_time: float = 0.15

var tween: Tween
var idx: int = 0

func _ready() -> void:
	await get_tree().get_root().ready
	initialize()

func _input(event: InputEvent) -> void:
	var last_idx: int = idx
	if event.is_action_pressed("ui_left", false):
		idx -= 1
	if event.is_action_pressed("ui_right", false):
		idx += 1
	idx = clamp(idx, 0, len(Player.Effect) - 1)
	if idx == last_idx:
		return
	if tween != null:
		tween.stop()
	tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position:x", OFFSET + idx * -ICON_SIZE, shift_time)

func initialize() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	for effect in GlobalMemory.data.unlocked_effects:
		var effect_name: String = Player.EFFECT_MAP[effect]
		var icon: Resource = load(ICON_DIR + effect_name + ".png")
		var rect: TextureRect = TextureRect.new()
		rect.texture = icon
		add_child(rect)
	for i in range(len(Player.Effect) - len(GlobalMemory.data.unlocked_effects)):
		var icon: Resource = load(ICON_DIR + "empty.png")
		var rect: TextureRect = TextureRect.new()
		rect.texture = icon
		add_child(rect)
	
	idx = GlobalMemory.data.unlocked_effects.find(CommonReference.player.effect)
	
	position.x = OFFSET + idx * ICON_SIZE
