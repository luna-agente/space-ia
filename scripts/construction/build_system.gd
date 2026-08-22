extends Node3D

const GRID_SIZE := 1.0
const RAY_LENGTH := 100.0

const BLOCK_SCENES := {
	"metal_1x1x1": preload("res://scenes/blocks/metal_block.tscn"),
	"triangle_1x1x1": preload("res://scenes/blocks/triangle_block.tscn"),
	"cylinder_1x1x1": preload("res://scenes/blocks/cylinder_block.tscn"),
}

@export var camera_path: NodePath
@export var blocks_root_path: NodePath
@export var hotbar_path: NodePath

var preview: Node3D
var preview_mesh: MeshInstance3D
var preview_material: StandardMaterial3D

@onready var camera: Camera3D = get_node(camera_path)
@onready var blocks_root: Node3D = get_node(blocks_root_path)
@onready var hotbar: HBoxContainer = get_node(hotbar_path)

func _ready() -> void:
	_create_preview()

func _process(_delta: float) -> void:
	var hit := _raycast_from_camera()
	if hit.is_empty():
		preview.visible = false
		return

	var normal: Vector3 = hit.normal
	var hit_position: Vector3 = hit.position
	var candidate := _snap_position(hit_position + normal * 0.5)
	preview.position = candidate
	preview.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_build_block()
			get_viewport().set_input_as_handled()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_remove_block()
			get_viewport().set_input_as_handled()

func _raycast_from_camera() -> Dictionary:
	var center := get_viewport().get_visible_rect().size * 0.5
	var origin := camera.project_ray_origin(center)
	var direction := camera.project_ray_normal(center)
	var query := PhysicsRayQueryParameters3D.create(origin, origin + direction * RAY_LENGTH)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	return camera.get_world_3d().direct_space_state.intersect_ray(query)

func _snap_position(position_value: Vector3) -> Vector3:
	return Vector3(
		round(position_value.x / GRID_SIZE) * GRID_SIZE,
		round(position_value.y / GRID_SIZE) * GRID_SIZE,
		round(position_value.z / GRID_SIZE) * GRID_SIZE
	)

func _build_block() -> void:
	var item_id: String = hotbar.get_selected_item()
	if item_id.is_empty() or not BLOCK_SCENES.has(item_id):
		return

	var hit := _raycast_from_camera()
	if hit.is_empty():
		return

	var normal: Vector3 = hit.normal
	var candidate := _snap_position(hit.position + normal * 0.5)
	if _has_block_at(candidate):
		return

	var block_scene: PackedScene = BLOCK_SCENES[item_id]
	var block := block_scene.instantiate()
	block.position = candidate
	blocks_root.add_child(block)

func _remove_block() -> void:
	var hit := _raycast_from_camera()
	if hit.is_empty():
		return

	var collider: Object = hit.collider
	if collider is Node:
		var node := collider as Node
		if node.has_meta("block_id"):
			node.queue_free()

func _has_block_at(target_position: Vector3) -> bool:
	for child in blocks_root.get_children():
		if child is Node3D and (child as Node3D).global_position.distance_to(target_position) < 0.01:
			return true
	return false

func _create_preview() -> void:
	preview = BLOCK_SCENES["metal_1x1x1"].instantiate()
	preview.name = "BuildPreview"
	preview.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(preview)
	_set_preview_material()

func _set_preview_material() -> void:
	preview_material = StandardMaterial3D.new()
	preview_material.albedo_color = Color(0.25, 0.8, 1.0, 0.35)
	preview_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	preview_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	preview_material.no_depth_test = true

	preview_mesh = preview.get_node("Mesh") as MeshInstance3D
	preview_mesh.material_override = preview_material

	var collision := preview.get_node_or_null("Collision")
	if collision:
		collision.set_deferred("disabled", true)

func _update_preview_block() -> void:
	var item_id: String = hotbar.get_selected_item()
	if item_id.is_empty() or not BLOCK_SCENES.has(item_id):
		preview.visible = false
		return

	var current_id := str(preview.get_meta("block_id", ""))
	if current_id == item_id:
		return

	var old_position := preview.position
	preview.queue_free()
	preview = BLOCK_SCENES[item_id].instantiate()
	preview.name = "BuildPreview"
	preview.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(preview)
	preview.position = old_position
	_set_preview_material()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PROCESS:
		_update_preview_block()
