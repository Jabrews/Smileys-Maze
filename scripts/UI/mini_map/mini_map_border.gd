extends Node3D

@export var is_bottom_right : bool

func _ready() -> void:
	
	# determine which border this node represents
	var border_type = "bottom-right" if is_bottom_right else "top-left"
	
	# send border type and its global position
	GlSignalBus.emit_signal("mini_map_border_set", border_type, global_position)
