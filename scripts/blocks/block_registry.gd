class_name BlockRegistry
extends RefCounted

const METAL_SCENE: PackedScene = preload("res://scenes/blocks/metal_block.tscn")
const TRIANGLE_SCENE: PackedScene = preload("res://scenes/blocks/triangle_block.tscn")
const CYLINDER_SCENE: PackedScene = preload("res://scenes/blocks/cylinder_block.tscn")

var _definitions: Dictionary[String, BlockDefinition] = {}

func _init() -> void:
	_register(BlockDefinition.new("metal_1x1x1", "Metal", "structural", Vector3.ONE, METAL_SCENE))
	_register(BlockDefinition.new("triangle_1x1x1", "Triangle", "structural", Vector3.ONE, TRIANGLE_SCENE))
	_register(BlockDefinition.new("cylinder_1x1x1", "Cylinder", "structural", Vector3.ONE, CYLINDER_SCENE))

func _register(definition: BlockDefinition) -> void:
	_definitions[definition.id] = definition

func get_definition(block_id: String) -> BlockDefinition:
	return _definitions.get(block_id) as BlockDefinition

func has_block(block_id: String) -> bool:
	return _definitions.has(block_id)

func get_all_ids() -> Array[String]:
	var ids: Array[String] = []
	for key: String in _definitions.keys():
		ids.append(str(key))
	return ids
