extends Node

@export var player : CharacterBody3D 

var floor_one_nodes : Node3D
var floor_two_nodes : Node3D
var floor_three_nodes : Node3D

var closest_node : Node3D
var closest_node_floor : int

func _ready() -> void:
	GlSignalBus.connect('player_near_paper', _handle_player_near_paper)
	GlSignalBus.connect('player_not_near_paper', _handle_player_not_near_paper)
	

func get_player_floor() :
	var player_pos_y = player.global_position.y
	if player_pos_y <= 14:
		closest_node_floor = 1
		return get_parent().floor_one_nodes
	elif player_pos_y > 14 and player_pos_y <= 32 :
		closest_node_floor = 2
		return get_parent().floor_two_nodes
	elif player_pos_y > 32 :
		closest_node_floor = 3
		return get_parent().floor_three_nodes 

func _handle_player_near_paper() :
	
	
	var selected_floor_nodes = get_player_floor()
	
	var closest : Node3D
	var best_dist := INF

	for n: Node3D in selected_floor_nodes.get_children():
		var d = player.global_position.distance_squared_to(n.global_position)

		if d < best_dist:
			best_dist = d
			closest = n

	closest_node = closest
	
		
		
func _handle_player_not_near_paper() :
	closest_node = null

## this is what is called by dice roll
func get_closest_node(smiley_floor: int) :
	if closest_node != null :
		if smiley_floor == closest_node_floor :
			return closest_node
	else :
		return null 
