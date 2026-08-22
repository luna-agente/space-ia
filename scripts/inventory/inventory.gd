extends Node

class_name PlayerInventory

const SLOT_COUNT := 10

const EMPTY := ""
const METAL := "metal_1x1x1"
const TRIANGLE := "triangle_1x1x1"
const CYLINDER := "cylinder_1x1x1"
const CUBE_1X2X1 := "cube_1x2x1"
const HALF_CUBE := "half_cube_1x1x1"
const WEDGE := "wedge_1x1x1"
const CONE := "cone_1x1x1"
const QUARTER_CUBE := "quarter_cube_1x1x1"

var slots: Array[String] = [
	METAL,
	TRIANGLE,
	CYLINDER,
	CUBE_1X2X1,
	HALF_CUBE,
	WEDGE,
	CONE,
	QUARTER_CUBE,
	EMPTY,
	EMPTY,
]

var selected_slot: int = 0

func select_slot(slot_index: int) -> void:
	selected_slot = clampi(slot_index, 0, SLOT_COUNT - 1)

func get_selected_item() -> String:
	return slots[selected_slot]

func get_item(slot_index: int) -> String:
	if slot_index < 0 or slot_index >= SLOT_COUNT:
		return EMPTY
	return slots[slot_index]
