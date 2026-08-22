extends Control

@export var ui_manager_path: NodePath

@onready var ui_manager: Node = get_node(ui_manager_path)

func _ready() -> void:
	visible = false

func toggle() -> void:
	visible = not visible
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_pressed() -> void:
	visible = false
	ui_manager.call("resume_game")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_quit_pressed() -> void:
	get_tree().quit()
