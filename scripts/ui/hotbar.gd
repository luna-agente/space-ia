extends HBoxContainer

const SLOT_COUNT: int = 10

@export var inventory_path: NodePath
@export var catalog_path: NodePath

var selected_slot: int = 0
var slots: Array[Button] = []
@onready var inventory: PlayerInventory = get_node(inventory_path) as PlayerInventory
@onready var catalog: BlockCatalog = get_node(catalog_path) as BlockCatalog

func _ready() -> void:
	for index: int in range(SLOT_COUNT):
		var slot: Button = Button.new()
		slot.custom_minimum_size = Vector2(88, 76)
		slot.focus_mode = Control.FOCUS_NONE
		slot.mouse_default_cursor_shape = Control.CURSOR_ARROW
		slot.pressed.connect(select_slot.bind(index))
		add_child(slot)
		slots.append(slot)
	_update_selection()

func _process(_delta: float) -> void:
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
	for index: int in range(slots.size()):
		var item_id: String = inventory.get_hotbar_item(index)
		var key_number: int = index + 1 if index < 9 else 0
		var label: String = inventory.get_item_display_name(item_id)
		var count: int = inventory.get_item_count(item_id)
		slots[index].text = "%d\n%s\n%d" % [key_number, label, count] if not item_id.is_empty() else "%d\n—" % key_number
		_update_slot_icon(slots[index], item_id)
		slots[index].modulate = Color(1.0, 1.0, 0.65) if index == selected_slot else Color.WHITE

func _update_slot_icon(button: Button, item_id: String) -> void:
	if item_id.is_empty():
		button.icon = null
		return
	var definition: BlockDefinition = catalog.registry.get_definition(item_id)
	if definition == null or definition.scene == null:
		button.icon = null
		return
	button.icon = _create_block_icon(definition.scene)
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.expand_icon = true

func _create_block_icon(scene: PackedScene) -> Texture2D:
	var viewport: SubViewport = SubViewport.new()
	viewport.size = Vector2i(56, 40)
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	viewport.own_world_3d = true

	var root: Node3D = scene.instantiate() as Node3D
	if root == null:
		viewport.queue_free()
		return null
	viewport.add_child(root)

	var camera: Camera3D = Camera3D.new()
	camera.position = Vector3(2.2, 1.6, 2.2)
	camera.look_at_from_position(camera.position, Vector3.ZERO)
	camera.current = true
	viewport.add_child(camera)

	var light: DirectionalLight3D = DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-35, -25, 0)
	light.light_energy = 1.4
	light.shadow_enabled = false
	viewport.add_child(light)

	add_child(viewport)
	await RenderingServer.frame_post_draw
	var image: Image = viewport.get_texture().get_image()
	var texture: ImageTexture = ImageTexture.create_from_image(image)
	viewport.queue_free()
	return texture

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
