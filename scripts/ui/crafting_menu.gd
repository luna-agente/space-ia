extends Control

@export var inventory_path: NodePath
@export var catalog_path: NodePath

@onready var inventory: PlayerInventory = get_node(inventory_path) as PlayerInventory
@onready var catalog: BlockCatalog = get_node(catalog_path) as BlockCatalog
@onready var category_list: VBoxContainer = $Panel/Margin/VBox/Body/Categories/CategoryList
@onready var block_list: VBoxContainer = $Panel/Margin/VBox/Body/Blocks/BlockList
@onready var hotbar_list: HBoxContainer = $Panel/Margin/VBox/Footer/HotbarList
@onready var status_label: Label = $Panel/Margin/VBox/Footer/Status

var active_category: String = "All"
var selected_block_id: String = ""

func _ready() -> void:
	visible = false
	_build_categories()
	_refresh_blocks()
	_refresh_hotbar()

func toggle() -> void:
	visible = not visible
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		_refresh_blocks()
		_refresh_hotbar()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_T:
			toggle()
			get_viewport().set_input_as_handled()
		elif visible and event.keycode == KEY_ESCAPE:
			toggle()
			get_viewport().set_input_as_handled()

func _build_categories() -> void:
	for child in category_list.get_children():
		child.queue_free()
	_add_category_button("All")
	for category: String in catalog.registry.get_categories():
		_add_category_button(category)

func _add_category_button(category: String) -> void:
	var button: Button = Button.new()
	button.text = category.capitalize()
	button.custom_minimum_size = Vector2(150, 42)
	button.focus_mode = Control.FOCUS_NONE
	button.pressed.connect(_select_category.bind(category))
	category_list.add_child(button)

func _select_category(category: String) -> void:
	active_category = category
	_refresh_blocks()

func _refresh_blocks() -> void:
	for child in block_list.get_children():
		child.queue_free()

	for item_id: String in catalog.registry.get_all_ids():
		var definition: BlockDefinition = catalog.registry.get_definition(item_id)
		if definition == null:
			continue
		if active_category != "All" and definition.category != active_category:
			continue

		var button: Button = Button.new()
		button.text = "%s\n%s" % [definition.display_name, definition.category.capitalize()]
		button.custom_minimum_size = Vector2(220, 58)
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(_select_block.bind(item_id))
		block_list.add_child(button)

func _select_block(block_id: String) -> void:
	selected_block_id = block_id
	var definition: BlockDefinition = catalog.registry.get_definition(block_id)
	if definition == null:
		return
	status_label.text = "%s selecionado. Agora clique em um slot da hotbar." % definition.display_name
	_refresh_hotbar()

func _refresh_hotbar() -> void:
	for child in hotbar_list.get_children():
		child.queue_free()

	for slot_index: int in range(PlayerInventory.SLOT_COUNT):
		var item_id: String = inventory.get_hotbar_item(slot_index)
		var label: String = inventory.get_item_display_name(item_id) if not item_id.is_empty() else "Vazio"
		var key_number: int = slot_index + 1 if slot_index < 9 else 0
		var button: Button = Button.new()
		button.text = "%d\n%s" % [key_number, label]
		button.custom_minimum_size = Vector2(92, 56)
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(_assign_to_hotbar.bind(slot_index))
		hotbar_list.add_child(button)

func _assign_to_hotbar(slot_index: int) -> void:
	if selected_block_id.is_empty():
		status_label.text = "Selecione um bloco primeiro."
		return
	inventory.set_hotbar_item(slot_index, selected_block_id)
	status_label.text = "%s atribuído ao slot %d." % [inventory.get_item_display_name(selected_block_id), slot_index + 1 if slot_index < 9 else 10]
	_refresh_hotbar()
