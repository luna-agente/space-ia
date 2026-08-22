extends Control

@export var gameplay_root_path: NodePath
@export var menu_root_path: NodePath

@onready var gameplay_root: Node = get_node(gameplay_root_path)
@onready var menu_root: Control = get_node(menu_root_path)

func _ready() -> void:
	visible = true
	gameplay_root.process_mode = Node.PROCESS_MODE_DISABLED
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_play_pressed() -> void:
	visible = false
	gameplay_root.process_mode = Node.PROCESS_MODE_INHERIT
	menu_root.grab_focus()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_quit_pressed() -> void:
	get_tree().quit()
