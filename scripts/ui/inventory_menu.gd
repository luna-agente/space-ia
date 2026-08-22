extends Control

@export var inventory_path: NodePath

@onready var inventory: PlayerInventory = get_node(inventory_path) as PlayerInventory
@onready var item_grid: GridContainer = $Panel/Margin/VBox/ItemGrid

func _ready() -> void:
	visible = false
	_refresh()

func toggle() -> void:
	visible = not visible
	if visible:
		_refresh()

func refresh() -> void:
	_refresh()

func _refresh() -> void:
	for child: Node in item_grid.get_children():
		child.queue_free()

	for item_id: String in inventory.get_owned_item_ids():
		var button: Button = Button.new()
		button.custom_minimum_size = Vector2(180, 72)
		button.text = "%s\nQuantidade: %d" % [inventory.get_item_display_name(item_id), inventory.get_item_count(item_id)]
		button.focus_mode = Control.FOCUS_NONE
		item_grid.add_child(button)
