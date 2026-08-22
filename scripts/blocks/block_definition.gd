class_name BlockDefinition
extends RefCounted

var id: String
var display_name: String
var category: String
var size: Vector3
var scene: PackedScene

func _init(block_id: String, block_name: String, block_category: String, block_size: Vector3, block_scene: PackedScene) -> void:
	id = block_id
	display_name = block_name
	category = block_category
	size = block_size
	scene = block_scene
