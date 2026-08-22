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

func _on_play_pressed() -> void:
	visible = false
	player.process_mode = Node.PROCESS_MODE_INHERIT
	build_system.process_mode = Node.PROCESS_MODE_INHERIT
	ui_manager.call("resume_game")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_quit_pressed() -> void:
	get_tree().quit()
