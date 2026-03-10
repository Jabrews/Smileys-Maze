extends Node

# math
@export var mini_map_math_helper : Node

func _ready() -> void:
	GlSignalBus.connect("map_icon_delete", _handle_map_icon_delete)


func _handle_map_icon_delete(icon_name, icon_pos : Vector3) :
	var map_parent = mini_map_math_helper.decide_parent_from_height(icon_pos.y)
	var new_icon_name = "icon-" + icon_name 
	var icon = map_parent.get_node_or_null(new_icon_name)
	icon.emit_delete_particle()

	
	
