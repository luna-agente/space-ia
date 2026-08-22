extends Node

@export var inventory_menu_path: NodePath
@export var crafting_menu_path: NodePath
@export var hotbar_path: NodePath
@export var player_path: NodePath
@export var pause_menu_path: NodePath
@export var main_menu_path: NodePath

@onready var inventory_menu: Control = get_node(inventory_menu_path) as Control
@onready var crafting_menu: Control = get_node(crafting_menu_path) as Control
@onready var hotbar: Control = get_node(hotbar_path) as Control
@onready var player: Node3D = get_node(player_path) as Node3D
@onready var pause_menu: Control = get_node(pause_menu_path) as Control
@onready var main_menu: Control = get_node(main_menu_path) as Control

func _ready() -> void:
	_update_input_state()

func _process(_delta: float) -> void:
	_update_input_state()

func _update_input_state() -> void:
	var menu_open: bool = main_menu.visible or inventory_menu.visible or crafting_menu.visible or pause_menu.visible
	player.set_process(not menu_open)
	player.set_process_input(not menu_open)
	hotbar.visible = not menu_open
	if menu_open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		_set_mouse_captured()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event.pressed or event.echo or main_menu.visible:
		return

	match event.keycode:
		KEY_I:
			if not pause_menu.visible:
				if crafting_menu.visible:
					crafting_menu.toggle()
				inventory_menu.toggle()
			get_viewport().set_input_as_handled()
		KEY_T:
			if not pause_menu.visible:
				if inventory_menu.visible:
					inventory_menu.toggle()
				crafting_menu.toggle()
			get_viewport().set_input_as_handled()
		KEY_ESCAPE:
			if inventory_menu.visible:
				inventory_menu.toggle()
			elif crafting_menu.visible:
				crafting_menu.toggle()
			else:
				toggle_pause()
			get_viewport().set_input_as_handled()

func toggle_pause() -> void:
	pause_menu.toggle()

func resume_game() -> void:
	pause_menu.visible = false
	inventory_menu.visible = false
	crafting_menu.visible = false
	main_menu.visible = false
	_set_mouse_captured()

func _set_mouse_captured() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
