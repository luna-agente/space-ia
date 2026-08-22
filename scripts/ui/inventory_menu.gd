extends Control

@export var inventory_path: NodePath

@onready var inventory: PlayerInventory = get_node(inventory_path) as PlayerInventory
@onready var item_grid: GridContainer = $Panel/Margin/VBox/ItemGrid

var item_buttons: Array[Button] = []

func _ready() -> void:
	visible = false
	_build_item_grid()

func toggle() -> void:
	visible = not visible
	if visible:
		_capture_mouse()
		_refresh()
	else:
		_release_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_I:
		toggle()
		get_viewport().set_input_as_handled()
	elif visible and event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		toggle()
		get_viewport().set_input_as_handled()

func _build_item_grid() -> void:
	for child in item_grid.get_children():
		child.queue_free()
	item_buttons.clear()

	for item_id: String in inventory.get_owned_item_ids():
		var button: Button = Button.new()
		button.custom_minimum_size = Vector2(180, 72)
		button.text = "%s\nQuantidade: %d" % [inventory.get_item_display_name(item_id), inventory.get_item_count(item_id)]
		button.focus_mode = Control.FOCUS_NONE
		item_grid.add_child(button)
		item_buttons.append(button)

func _refresh() -> void:
	_build_item_grid()

func _capture_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _release_mouse() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
