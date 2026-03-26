extends Node

@export var elevator_body_center_mesh : MeshInstance3D

func _ready() -> void:
	
	# create icon
	GlSignalBus.emit_signal(
		'map_icon_object_init',
	 	'ELEVATOR',
		Vector3(9.50, 1.75, 37.40),
		name,
	)
