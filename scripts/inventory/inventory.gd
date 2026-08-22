extends Node

class_name PlayerInventory

const SLOT_COUNT: int = 10
const EMPTY: String = ""

var items: Dictionary[String, int] = {
	"metal_1x1x1": 100,
	"triangle_1x1x1": 100,
	"cylinder_1x1x1": 100,
	"cube_1x2x1": 100,
	"half_cube_1x1x1": 100,
	"wedge_1x1x1": 100,
	"cone_1x1x1": 100,
	"quarter_cube_1x1x1": 100,
}

var hotbar_slots: Array[String] = [
	"metal_1x1x1",
	"triangle_1x1x1",
	"cylinder_1x1x1",
	"cube_1x2x1",
	"half_cube_1x1x1",
	"wedge_1x1x1",
	"cone_1x1x1",
	"quarter_cube_1x1x1",
	EMPTY,
	EMPTY,
]

var selected_hotbar_slot: int = 0

const DISPLAY_NAMES: Dictionary[String, String] = {
	"metal_1x1x1": "Metal",
	"triangle_1x1x1": "Triangle",
	"cylinder_1x1x1": "Cylinder",
	"cube_1x2x1": "Cube 1×2×1",
	"half_cube_1x1x1": "Half Cube",
	"wedge_1x1x1": "Wedge",
	"cone_1x1x1": "Cone",
	"quarter_cube_1x1x1": "Quarter Cube",
	"": "Vazio",
}

func select_slot(slot_index: int) -> void:
	selected_hotbar_slot = clampi(slot_index, 0, SLOT_COUNT - 1)

func get_selected_item() -> String:
	return get_hotbar_item(selected_hotbar_slot)

func get_item(slot_index: int) -> String:
	return get_hotbar_item(slot_index)

func get_hotbar_item(slot_index: int) -> String:
	if slot_index < 0 or slot_index >= SLOT_COUNT:
		return EMPTY
	return hotbar_slots[slot_index]

func set_hotbar_item(slot_index: int, item_id: String) -> void:
	if slot_index < 0 or slot_index >= SLOT_COUNT:
		return
	hotbar_slots[slot_index] = item_id

func get_item_count(item_id: String) -> int:
	return int(items.get(item_id, 0))

func get_owned_item_ids() -> Array[String]:
	var ids: Array[String] = []
	for item_id: String in items.keys():
		if get_item_count(item_id) > 0:
			ids.append(item_id)
	return ids

func get_item_display_name(item_id: String) -> String:
	return DISPLAY_NAMES.get(item_id, item_id) as String
