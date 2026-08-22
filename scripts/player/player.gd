extends Node3D

@export var move_speed := 5.0
@export var rotation_speed := 1.8
@export var look_sensitivity := 0.0025

@onready var camera: Camera3D = $Camera3D

var pitch := 0.0
var yaw := 0.0

func _ready() -> void:
	camera.current = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * look_sensitivity
		pitch = clamp(pitch - event.relative.y * look_sensitivity, -PI * 0.49, PI * 0.49)
		rotation.y = yaw
		camera.rotation.x = pitch
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	var direction := Vector3.ZERO
	if Input.is_key_pressed(KEY_W):
		direction -= transform.basis.z
	if Input.is_key_pressed(KEY_S):
		direction += transform.basis.z
	if Input.is_key_pressed(KEY_A):
		direction -= transform.basis.x
	if Input.is_key_pressed(KEY_D):
		direction += transform.basis.x
	if Input.is_key_pressed(KEY_SPACE):
		direction += Vector3.UP
	if Input.is_key_pressed(KEY_C):
		direction -= Vector3.UP

	if direction.length_squared() > 0.0:
		position += direction.normalized() * move_speed * delta

	var rotation_direction := 0.0
	if Input.is_key_pressed(KEY_Q):
		rotation_direction -= 1.0
	if Input.is_key_pressed(KEY_E):
		rotation_direction += 1.0
	if rotation_direction != 0.0:
		yaw += rotation_direction * rotation_speed * delta
		rotation.y = yaw
