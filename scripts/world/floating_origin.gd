class_name FloatingOrigin
extends Node3D

@export var player_path: NodePath
@export var rebase_distance: float = 1000.0

@onready var player: Node3D = get_node(player_path) as Node3D

func _ready() -> void:
	_rebase_if_needed(true)

func _process(_delta: float) -> void:
	_rebase_if_needed(false)

func _rebase_if_needed(force: bool) -> void:
	if not is_instance_valid(player):
		return

	var offset: Vector3 = player.position
	if not force and offset.length() < rebase_distance:
		return
	if offset.length_squared() <= 0.000001:
		return

	var root: Node = get_parent()
	if root == null:
		return

	# Shift every local 3D object except the player and this controller.
	# The player returns to the local origin while preserving the visual layout.
	for child: Node in root.get_children():
		if child == player or child == self:
			continue
		if child is Node3D:
			var spatial: Node3D = child as Node3D
			spatial.position -= offset

	player.position = Vector3.ZERO
