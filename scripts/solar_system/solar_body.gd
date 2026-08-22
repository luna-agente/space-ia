class_name SolarBody
extends Node3D

@export var body_id: String = ""
@export var body_type: String = "celestial_body"
@export var radius_m: float = 100000.0
@export var orbit_radius_m: float = 0.0
@export var has_atmosphere: bool = false
@export var gravity_enabled: bool = false
