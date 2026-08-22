extends HBoxContainer

const SLOT_COUNT := 10
const ITEM_LABELS: Dictionary[String, String] = {
	"": "—",
	"metal_1x1x1": "Metal",
	"triangle_1x1x1": "Tri",
	"cylinder_1x1x1": "Cyl",
}

@export var inventory_path: NodePath

var selected_slot: int = 0
var slots: Array[Button] = []
@onready var inventory: PlayerInventory = get_node(inventory_path) as PlayerInventory

func _ready() -> void:
	for index in range(SLOT_COUNT):
		var slot: Button = Button.new()
		slot.custom_minimum_size = Vector2(68, 58)
		slot.focus_mode = Control.FOCUS_NONE
		slot.mouse_default_cursor_shape = Control.CURSOR_ARROW
		slot.pressed.connect(select_slot.bind(index))
		add_child(slot)
		slots.append(slot)

	_update_selection()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.pressed or event.echo:
		return

	var number: int = _number_from_key(event.keycode)
	if number >= 1 and number <= SLOT_COUNT:
		select_slot(number - 1)
		get_viewport().set_input_as_handled()

func select_slot(slot_index: int) -> void:
	selected_slot = clampi(slot_index, 0, SLOT_COUNT - 1)
	inventory.select_slot(selected_slot)
	_update_selection()

func get_selected_item() -> String:
	return inventory.get_selected_item()

func _update_selection() -> void:
	for index in slots.size():
		var item_id: String = inventory.get_item(index)
		var key_number: int = index + 1 if index < 9 else 0
		var label: String = ITEM_LABELS.get(item_id, item_id) as String
		slots[index].text = "%d\n%s" % [key_number, label]
		slots[index].modulate = Color(1.0, 1.0, 0.65) if index == selected_slot else Color.WHITE

func _number_from_key(keycode: Key) -> int:
	match keycode:
		KEY_1: return 1
		KEY_2: return 2
		KEY_3: return 3
		KEY_4: return 4
		KEY_5: return 5
		KEY_6: return 6
		KEY_7: return 7
		KEY_8: return 8
		KEY_9: return 9
		KEY_0: return 10
	return -1
