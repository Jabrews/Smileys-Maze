extends Node

@export var floor_one_nodes : Node3D
@export var floor_two_nodes : Node3D
@export var floor_three_nodes : Node3D

# children movement 
@onready var spots_near_paper : Node = $SpotsNearPaper
@onready var spots_near_player : Node = $SpotsNearPlayer

var player_curr_floor : int = 1

func _ready() -> void:
	GlSignalBus.connect('player_changed_floor', _handle_player_changed_floor)


# called by smiley in idle
func dice_roll_for_pos(floor_num : int) :

	if player_curr_floor != floor_num:
		floor_num = player_curr_floor					

	var player_near_paper_move_node = spots_near_player.get_closest_node(floor_num)
	var dice_roll = randi_range(1,100)

	if player_near_paper_move_node:

		if dice_roll <= 50:
			print("picked (player):", player_near_paper_move_node.name)
			return player_near_paper_move_node

		elif dice_roll <= 75:
			var spot_near_paper = spots_near_paper.get_random_spot(floor_num)
			if spot_near_paper:
				print("picked (paper):", spot_near_paper.name)
				return spot_near_paper
			else:
				print("picked (fallback player):", player_near_paper_move_node.name)
				return player_near_paper_move_node

		else:
			var rand = get_random_pos(floor_num)
			print("picked (random):", rand.name)
			return rand

	else:

		if dice_roll <= 60:
			var spot_near_paper = spots_near_paper.get_random_spot(floor_num)
			if spot_near_paper:
				print("picked (paper no player):", spot_near_paper.name)
				return spot_near_paper

		var rand = get_random_pos(floor_num)
		print("picked (random no player):", rand.name)
		return rand
	

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

func _handle_player_changed_floor(new_player_floor_num : int) :
	player_curr_floor = new_player_floor_num
