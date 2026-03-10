extends Node

# math
@export var mini_map_math_helper : Node 

# fog of war for player icon
@export var fog_of_war_manager : Node

var active_floor = 1

func _ready() -> void:
	GlSignalBus.connect("icon_moved", _handle_icon_moved)
	GlSignalBus.connect('icon_changed_floor', _handle_icon_changed_floor)

func _handle_icon_changed_floor(icon_name, icon_type, icon_pos, new_floor : int):

	var map_nodes = mini_map_math_helper.get_map_nodes()
	var new_map_parent = mini_map_math_helper.get_map_node_from_floor_num(new_floor)
	var new_icon_name = "icon-" + icon_name

	for map_parent in map_nodes:
		var icon = map_parent.get_node_or_null(new_icon_name)

		if icon and new_map_parent:
			icon.reparent(new_map_parent)
			icon.position = mini_map_math_helper.world_to_minimap(icon_pos.x, icon_pos.z)
			break
	
		

func _handle_icon_moved(icon_name, icon_type, icon_pos : Vector3) :
	var map_parent = mini_map_math_helper.decide_parent_from_height(icon_pos.y)
	var new_icon_name = "icon-" + icon_name 
	var icon = map_parent.get_node_or_null(new_icon_name)
	# can become null in vent loading for player
	
	
	if icon :
		icon.position = mini_map_math_helper.world_to_minimap(icon_pos.x, icon_pos.z)
		
		if icon_type == 'PLAYER' :	
			# mini map shader
			var icon_shader_uv_pos = mini_map_math_helper.world_to_minimap_uv(icon_pos.x, icon_pos.z)
			fog_of_war_manager._handle_player_moved_shader_update(icon_shader_uv_pos)
			# mini map icon 
			GlSignalBus.emit_signal('player_moved', icon.position)
				
	
