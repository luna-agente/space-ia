extends Node

class_name PlayerInventory

const SLOT_COUNT := 10

const EMPTY := ""
const METAL := "metal_1x1x1"
const TRIANGLE := "triangle_1x1x1"
const CYLINDER := "cylinder_1x1x1"

var slots: Array[String] = [
	METAL,
	TRIANGLE,
	CYLINDER,
	EMPTY,
	EMPTY,
	EMPTY,
	EMPTY,
	EMPTY,
	EMPTY,
	EMPTY,
]

var selected_slot := 0

func select_slot(slot_index: int) -> void:
	selected_slot = clampi(slot_index, 0, SLOT_COUNT - 1)

func get_selected_item() -> String:
	return slots[selected_slot]

func get_item(slot_index: int) -> String:
	if slot_index < 0 or slot_index >= SLOT_COUNT:
		return EMPTY
	return slots[slot_index]
