extends Node

@export var floor_one_nodes : Node3D
@export var floor_two_nodes : Node3D
@export var floor_three_nodes : Node3D

# children movement 
@onready var spots_near_paper : Node = $SpotsNearPaper
@onready var spots_near_player : Node = $SpotsNearPlayer


# called by smiley in idle
func dice_roll_for_pos(floor_num : int) :
	# see if player near paper valid
	var player_near_paper_move_node = spots_near_player.get_closest_node(floor_num)

	# roll 1–100
	var dice_roll = randi_range(1,100)

	if player_near_paper_move_node:

		# 50% go near player
		if dice_roll <= 50:
			return player_near_paper_move_node

		# 25% go to paper node
		elif dice_roll <= 75:
			var spot_near_paper = spots_near_paper.get_random_spot(floor_num)
			if spot_near_paper:
				return spot_near_paper
			else:
				return player_near_paper_move_node

		# 25% random roam
		else:
			return get_random_pos(floor_num)

	else:
		# player not near paper

		# 60% paper
		if dice_roll <= 60:
			var spot_near_paper = spots_near_paper.get_random_spot(floor_num)
			if spot_near_paper:
				return spot_near_paper

		# 40% random
		return get_random_pos(floor_num)
	
	
	
	

func get_random_pos(floor_num : int) :
	var floor_nodes = get_floor_nodes(floor_num)
	var floor_nodes_children = floor_nodes.get_children()
	## get random num
	var max_index = len(floor_nodes_children) - 1
	var random_index = randi_range(0, max_index)
	return floor_nodes_children[random_index]
	
func get_floor_nodes(floor_num : int) :
	print(floor_one_nodes, floor_two_nodes, floor_three_nodes)
	match floor_num:
		1:
			return floor_one_nodes
		2:
			return floor_two_nodes
		3:
			return floor_three_nodes
