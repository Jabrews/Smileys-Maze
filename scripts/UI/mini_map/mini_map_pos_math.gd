extends Node

# world bounds (your level borders)
var top_left_border_pos : Vector2
var bottom_right_border_pos : Vector2

# controll parents for adding floor
@export var map_one_node: Control
@export var map_two_node : Control
@export var map_three_node : Control



# minimap size in pixels
var map_size : Vector2 = Vector2(110, 70)

func _ready() -> void:
	GlSignalBus.connect('mini_map_border_set', _handle_border_set)

## set border for worldspace, helper for world_to_minimap
func _handle_border_set(type, global_pos : Vector3) :
	if type == 'top-left' :
		top_left_border_pos = Vector2(global_pos.x, global_pos.z)
	if type == 'bottom-right' :
		bottom_right_border_pos = Vector2(global_pos.x, global_pos.z)
	
# convert world space to mini map pos
func world_to_minimap(world_pos_x, world_pos_z) -> Vector2:
	# step 1: normalize position inside world bounds
	var x_ratio = (world_pos_x - top_left_border_pos.x) / (bottom_right_border_pos.x - top_left_border_pos.x)
	var y_ratio = (world_pos_z - top_left_border_pos.y) / (bottom_right_border_pos.y - top_left_border_pos.y)
	
	# step 2: convert normalized value to minimap pixels
	var map_x = x_ratio * map_size.x
	var map_y = y_ratio * map_size.y
	
	return Vector2(map_x, map_y)

# covert world space to shader UV pos
func world_to_minimap_uv(world_pos_x, world_pos_z) -> Vector2:

	var x_ratio = (world_pos_x - top_left_border_pos.x) / (bottom_right_border_pos.x - top_left_border_pos.x)
	var y_ratio = (world_pos_z - top_left_border_pos.y) / (bottom_right_border_pos.y - top_left_border_pos.y)

	return Vector2(x_ratio, y_ratio)

# get floor based on y height
func decide_parent_from_height(icon_pos_y) :
	if icon_pos_y <= 14:
		return map_one_node
	elif icon_pos_y > 14 and icon_pos_y <= 32 :
		return map_two_node
	elif icon_pos_y > 32 :
		return map_three_node
	
# helper to get all floor nodes 
func get_map_nodes() :
	return [map_one_node, map_two_node, map_three_node]

func get_map_node_from_floor_num(floorNum : int) :
	if floorNum == 1 :
		return map_one_node
	if floorNum == 2 :
		return map_two_node
	if floorNum == 3 :
		return map_three_node
