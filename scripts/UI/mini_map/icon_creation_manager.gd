extends Node

# icon scene
var mini_map_icon_scene : PackedScene = preload("res://scenes/mini_map_icon.tscn")

# math
@export var mini_map_math_helper : Node 

func _ready() -> void:
	GlSignalBus.connect("map_icon_object_init", _handle_map_icon_obj_init)
	


# signal : create icon in correct floor
func _handle_map_icon_obj_init(icon_type, icon_global_pos : Vector3, icon_name):
	
	var icon = mini_map_icon_scene.instantiate()
	icon.icon_type = icon_type
	icon.name = "icon-" + icon_name
	



	var map_parent =  mini_map_math_helper.decide_parent_from_height(icon_global_pos.y)
	icon.position = mini_map_math_helper.world_to_minimap(icon_global_pos.x, icon_global_pos.z)
	

	
	map_parent.add_child(icon)
	
