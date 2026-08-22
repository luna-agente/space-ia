extends HBoxContainer

const SLOT_COUNT := 10
var selected_slot := 1
var slots: Array[Button] = []

func _ready() -> void:
	for index in range(SLOT_COUNT):
		var slot := Button.new()
		slot.custom_minimum_size = Vector2(52, 52)
		slot.text = str(index + 1)
		slot.focus_mode = Control.FOCUS_NONE
		slot.mouse_default_cursor_shape = Control.CURSOR_ARROW
		add_child(slot)
		slots.append(slot)
	_update_selection()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.pressed or event.echo:
		return

	var number := _number_from_key(event.keycode)
	if number >= 1 and number <= SLOT_COUNT:
		select_slot(number)
		get_viewport().set_input_as_handled()

func select_slot(slot_number: int) -> void:
	selected_slot = clampi(slot_number, 1, SLOT_COUNT)
	_update_selection()

func _update_selection() -> void:
	for index in slots.size():
		var slot_number := index + 1
		slots[index].text = "[%d]" % slot_number if slot_number == selected_slot else str(slot_number)
		slots[index].modulate = Color(1.0, 1.0, 0.65) if slot_number == selected_slot else Color.WHITE

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
