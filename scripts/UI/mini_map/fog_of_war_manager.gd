extends Node

# math
@export var mini_map_math_helper : Node 

@onready var map_one_node : Control = $"../MapFloorOne"
@onready var map_one_sprite_dark : Sprite2D = $"../MapFloorOne/MapDark"
@onready var map_one_sprite_light : Sprite2D = $"../MapFloorOne/MapLight"

@onready var map_two_node : Control = $"../MapFloorTwo"
@onready var map_two_sprite_dark : Sprite2D = $"../MapFloorTwo/MapDark"
@onready var map_two_sprite_light : Sprite2D = $"../MapFloorTwo/MapLight"

@onready var map_three_node : Control = $"../MapFloorThree"
@onready var map_three_sprite_dark : Sprite2D = $"../MapFloorThree/MapDark"
@onready var map_three_sprite_light : Sprite2D = $"../MapFloorThree/MapLight"

	
func _handle_player_moved_shader_update(player_pos : Vector2) :

	update_floor_shader(map_one_sprite_dark, map_one_sprite_light, player_pos, map_one_node)
	update_floor_shader(map_two_sprite_dark, map_two_sprite_light, player_pos, map_two_node)
	update_floor_shader(map_three_sprite_dark, map_three_sprite_light, player_pos, map_three_node)
	
	
func update_floor_shader(map_dark : Sprite2D, map_light : Sprite2D, player_pos : Vector2, _map_node):

	# dark map
	if map_dark.material:
		map_dark.material.set_shader_parameter("player_uv", player_pos)

	# light map
	if map_light.material:
		map_light.material.set_shader_parameter("player_uv", player_pos)


	## icons (children of light map)
	#for child in map_node.get_children():
		#if child is Sprite2D and child.name.contains('icon')  :
			##var new_player_pos = get_player_pos_screen_uv(player_pos)
			#var new_player_pos = get_player_pos_screen_uv(player_pos)
			#child.material.set_shader_parameter("player_uv", new_player_pos)
	
	
func get_player_pos_screen_uv(player_pos) :
	var viewport_size = get_viewport().get_visible_rect().size

	var screen_uv = Vector2(
		player_pos.x / viewport_size.x,
		player_pos.y / viewport_size.y
	)

	return screen_uv
	
