class_name BlockFactory
extends RefCounted

static func create(block_id: String, registry: BlockRegistry) -> Node3D:
	var definition: BlockDefinition = registry.get_definition(block_id)
	if definition == null or definition.scene == null:
		push_error("Unknown block id: %s" % block_id)
		return null

	return definition.scene.instantiate() as Node3D
