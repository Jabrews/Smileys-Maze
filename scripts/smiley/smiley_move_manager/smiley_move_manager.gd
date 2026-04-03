extends Node

@export var floor_one_nodes : Node3D
@export var floor_two_nodes : Node3D
@export var floor_three_nodes : Node3D

# children movement 
@onready var spots_near_paper : Node = $SpotsNearPaper
@onready var spots_near_player : Node = $SpotsNearPlayer
@onready var player_postion : Node = $PlayerPosition

var player_curr_floor : int = 1
var total_papers = 6


func _ready() -> void:
	GlSignalBus.connect('player_changed_floor', _handle_player_changed_floor)
	GlSignalBus.connect('delete_paper_coords', _handle_paper_deleted)


# called by smiley in idle
func dice_roll_for_pos(floor_num : int):

	if player_curr_floor != floor_num:
		floor_num = player_curr_floor

	var player_near_paper_move_node = spots_near_player.get_closest_node(floor_num)
	var spot_near_paper = spots_near_paper.get_random_spot(floor_num)
	var player_pos = player_postion.get_random_nav_point_around_player()
	var rand = get_random_pos(floor_num)

	var player_near_paper := player_near_paper_move_node != null
	var dice_roll = randi_range(1, 100)

	# no papers left
	if total_papers <= 0:
		if dice_roll <= 20:
			return rand
		else:
			return player_pos

	# papers 1-2 left
	if total_papers <= 2:
		if player_near_paper:
			# 5% random
			# 20% towards player
			# 75% towards player's paper node
			if dice_roll <= 5:
				return rand
			elif dice_roll <= 25:
				return player_pos
			else:
				return player_near_paper_move_node
		else:
			# 20% random
			# 50% towards paper
			# 30% towards player
			if dice_roll <= 20:
				return rand
			elif dice_roll <= 70:
				if spot_near_paper:
					return spot_near_paper
				return rand
			else:
				return player_pos

	# papers 3-4 left
	elif total_papers <= 4:
		if player_near_paper:
			# 1% random
			# 19% towards player's paper node
			# 80% towards player
			if dice_roll <= 1:
				return rand
			elif dice_roll <= 20:
				return player_near_paper_move_node
			else:
				return player_pos
		else:
			# 10% random
			# 20% towards paper
			# 70% towards player
			if dice_roll <= 10:
				return rand
			elif dice_roll <= 25:
				if spot_near_paper:
					return spot_near_paper
				return rand
			else:
				return player_pos

	# papers 5-6 left
	else:
		if player_near_paper:
			# 1% random
			# 1% towards player's paper node
			# 98% towards player
			if dice_roll <= 1:
				return rand
			elif dice_roll <= 2:
				return player_near_paper_move_node
			else:
				return player_pos
		else:
			# 1% random
			# 24% towards paper
			# 75% towards player
			if dice_roll <= 1:
				return rand
			elif dice_roll <= 15:
				if spot_near_paper:
					return spot_near_paper
				return rand
			else:
				return player_pos


func get_random_pos(floor_num : int):
	var floor_nodes = get_floor_nodes(floor_num)
	var floor_nodes_children = floor_nodes.get_children()

	var max_index = len(floor_nodes_children) - 1
	var random_index = randi_range(0, max_index)
	return floor_nodes_children[random_index]


func get_floor_nodes(floor_num : int):
	match floor_num:
		1:
			return floor_one_nodes
		2:
			return floor_two_nodes
		3:
			return floor_three_nodes


func _handle_player_changed_floor(new_player_floor_num : int):
	player_curr_floor = new_player_floor_num


func _handle_paper_deleted(_paper_name):
	total_papers -= 1
