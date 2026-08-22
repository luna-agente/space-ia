extends Node

@export var inventory_menu_path: NodePath
@export var crafting_menu_path: NodePath
@export var hotbar_path: NodePath
@export var player_path: NodePath

@onready var inventory_menu: Control = get_node(inventory_menu_path) as Control
@onready var crafting_menu: Control = get_node(crafting_menu_path) as Control
@onready var hotbar: Control = get_node(hotbar_path) as Control
@onready var player: Node3D = get_node(player_path) as Node3D

func _ready() -> void:
	_set_mouse_captured()

func _process(_delta: float) -> void:
	var menu_open := inventory_menu.visible or crafting_menu.visible
	player.set_process(not menu_open)
	player.set_process_input(not menu_open)
	hotbar.visible = not menu_open
	if menu_open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		_set_mouse_captured()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.pressed or event.echo:
		return
	if event.keycode == KEY_I:
		if crafting_menu.visible:
			crafting_menu.toggle()
		inventory_menu.toggle()
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_T:
		if inventory_menu.visible:
			inventory_menu.toggle()
		crafting_menu.toggle()
		get_viewport().set_input_as_handled()

func _set_mouse_captured() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
