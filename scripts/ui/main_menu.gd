extends Control

@export var player_path: NodePath
@export var build_system_path: NodePath
@export var ui_manager_path: NodePath

@onready var player: Node = get_node(player_path)
@onready var build_system: Node = get_node(build_system_path)
@onready var ui_manager: Node = get_node(ui_manager_path)

func _ready() -> void:
	visible = true
	player.process_mode = Node.PROCESS_MODE_DISABLED
	build_system.process_mode = Node.PROCESS_MODE_DISABLED
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_setup_menu_layout()
	_create_solar_system_preview()

func _setup_menu_layout() -> void:
	$Title.position = Vector2(70.0, 150.0)
	$Title.size = Vector2(490.0, 65.0)
	$Title.add_theme_font_size_override("font_size", 44)
	$Subtitle.position = Vector2(70.0, 220.0)
	$Subtitle.size = Vector2(490.0, 40.0)
	$Subtitle.add_theme_font_size_override("font_size", 18)
	$Play.position = Vector2(215.0, 320.0)
	$Play.size = Vector2(200.0, 60.0)
	$Play.add_theme_font_size_override("font_size", 20)
	$Quit.position = Vector2(215.0, 400.0)
	$Quit.size = Vector2(200.0, 60.0)
	$Quit.add_theme_font_size_override("font_size", 20)

func _create_solar_system_preview() -> void:
	var container: SubViewportContainer = SubViewportContainer.new()
	container.name = "SolarSystem"
	container.position = Vector2(620.0, 30.0)
	container.size = Vector2(532.0, 660.0)
	container.stretch = true
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(container)

	var viewport: SubViewport = SubViewport.new()
	viewport.name = "Viewport"
	viewport.size = Vector2i(532, 660)
	viewport.transparent_bg = false
	viewport.handle_input_locally = false
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.set_script(load("res://scripts/ui/solar_system_preview.gd"))
	container.add_child(viewport)

func _on_play_pressed() -> void:
	visible = false
	player.process_mode = Node.PROCESS_MODE_INHERIT
	build_system.process_mode = Node.PROCESS_MODE_INHERIT
	ui_manager.call("resume_game")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_quit_pressed() -> void:
	get_tree().quit()
