extends SubViewport

@export var orbit_speed: float = 0.25

var orbit_times: Array[float] = [0.0, 2.0, 4.2]
# Every orbit remains safely outside the sun radius (1.35).
var orbit_radii: Array[float] = [4.0, 6.8, 9.8]
var orbit_sizes: Array[float] = [0.45, 0.7, 0.95]
var planet_colors: Array[Color] = [
	Color(0.25, 0.55, 0.95),
	Color(0.82, 0.42, 0.24),
	Color(0.48, 0.78, 0.52),
]
var planets: Array[MeshInstance3D] = []
var sun: MeshInstance3D

func _ready() -> void:
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_create_scene()

func _process(delta: float) -> void:
	for index: int in range(planets.size()):
		orbit_times[index] += delta * orbit_speed * (1.0 + index * 0.18)
		var angle: float = orbit_times[index]
		var radius: float = orbit_radii[index]
		planets[index].position = Vector3(2.2 + cos(angle) * radius, sin(angle * 0.72) * 0.65, sin(angle) * radius)
		planets[index].rotation.y += delta * (0.45 + index * 0.15)
	if is_instance_valid(sun):
		sun.rotation.y += delta * 0.08

func _create_scene() -> void:
	var root: Node3D = Node3D.new()
	add_child(root)

	var environment: WorldEnvironment = WorldEnvironment.new()
	var environment_data: Environment = Environment.new()
	environment_data.background_mode = Environment.BG_COLOR
	environment_data.background_color = Color(0.003, 0.005, 0.015)
	environment_data.background_energy_multiplier = 0.18
	environment.environment = environment_data
	root.add_child(environment)

	var camera: Camera3D = Camera3D.new()
	camera.position = Vector3(0.0, 1.6, 21.0)
	camera.look_at_from_position(camera.position, Vector3(2.2, 0.4, 0.0))
	camera.fov = 42.0
	camera.current = true
	root.add_child(camera)

	var key_light: DirectionalLight3D = DirectionalLight3D.new()
	key_light.rotation_degrees = Vector3(-38.0, -24.0, 0.0)
	key_light.light_energy = 1.2
	key_light.shadow_enabled = false
	root.add_child(key_light)

	sun = _create_sphere(root, Vector3(2.2, 4.2, -0.2), 1.35, Color(1.0, 0.74, 0.18), true)
	var sun_light: OmniLight3D = OmniLight3D.new()
	sun_light.position = sun.position
	sun_light.light_color = Color(1.0, 0.72, 0.32)
	sun_light.light_energy = 8.0
	sun_light.omni_range = 18.0
	sun_light.shadow_enabled = false
	root.add_child(sun_light)

	for index: int in range(3):
		var planet: MeshInstance3D = _create_sphere(root, Vector3.ZERO, orbit_sizes[index], planet_colors[index], false)
		planet.position = Vector3(2.2 + orbit_radii[index], 0.0, 0.0)
		planet.rotation_degrees = Vector3(0.0, 0.0, 4.0 + index * 5.0)
		planets.append(planet)
		_create_orbit(root, 2.2, orbit_radii[index])

func _create_sphere(parent: Node3D, position_value: Vector3, radius: float, color_value: Color, emissive: bool) -> MeshInstance3D:
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.albedo_color = color_value
	material.roughness = 0.55
	if emissive:
		material.emission_enabled = true
		material.emission = color_value
		material.emission_energy_multiplier = 4.0

	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 32
	mesh.rings = 16
	mesh.material = material

	var instance: MeshInstance3D = MeshInstance3D.new()
	instance.mesh = mesh
	instance.position = position_value
	parent.add_child(instance)
	return instance

func _create_orbit(parent: Node3D, center_x: float, radius: float) -> void:
	var line: ImmediateMesh = ImmediateMesh.new()
	line.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	for step: int in range(65):
		var angle: float = TAU * float(step) / 64.0
		line.surface_set_color(Color(0.28, 0.35, 0.55, 0.28))
		line.surface_add_vertex(Vector3(center_x + cos(angle) * radius, 0.0, sin(angle) * radius))
	line.surface_end()

	var mesh_instance: MeshInstance3D = MeshInstance3D.new()
	mesh_instance.mesh = line
	parent.add_child(mesh_instance)
