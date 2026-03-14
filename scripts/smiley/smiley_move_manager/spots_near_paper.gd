extends Node

var papers : Dictionary[int, PaperMoveObj] = {}

var floor_one_spots_near_paper : Dictionary[int, Array] = {}
var floor_two_spots_near_paper : Dictionary[int, Array] = {}
var floor_three_spots_near_paper : Dictionary[int, Array] = {}

# components

func _ready() -> void:
	
	# runs when paper created
	GlSignalBus.connect('paper_object_created', _handle_paper_object_created)
	
	# runs when paper collected
	GlSignalBus.connect('delete_paper_coords', _handle_delete_paper_coords)

	# wait untill we get all papers
	while not papers.has(9):
		await get_tree().process_frame
	
	# populate spots near paper
	floor_spots_near_paper_gen()
	#print(floor_one_spots_near_paper)
	#print(floor_two_spots_near_paper)
	#print(floor_three_spots_near_paper)
		
# get each paper and find nodes around it
func _handle_paper_object_created(paper_name, paper_glob_pos : Vector3, floor_num : int) :
	var dic_index = paper_name_to_dic_index(paper_name)
	var p := PaperMoveObj.new()
	p.paper_name = paper_name
	p.paper_glob_pos = paper_glob_pos
	p.floor_num = floor_num
	# add to dic. at correct index
	papers[dic_index] = p

# helper for finding papers index
func paper_name_to_dic_index(paper_name: String) -> int:
	# all are named 'paper' or 'paper1'

	# if no number at end, it's the first paper
	if paper_name.length() <= 5:
		return 1

	var last_char = paper_name[5]
	return int(last_char)
	
	
func floor_spots_near_paper_gen():

	var curr_index := 1

	while curr_index <= 9:

		var curr_p : PaperMoveObj = papers[curr_index]

		var floor_nodes : Node

		# choose correct floor
		match curr_p.floor_num:
			1:
				floor_nodes = get_parent().floor_one_nodes
			2:
				floor_nodes = get_parent().floor_two_nodes
			3:
				floor_nodes = get_parent().floor_three_nodes

		var nodes := floor_nodes.get_children()

		# sort nodes by distance to paper
		nodes.sort_custom(func(a, b):
			return a.global_position.distance_to(curr_p.paper_glob_pos) < b.global_position.distance_to(curr_p.paper_glob_pos)
		)

		# store the 3 closest nodes
		var closest_nodes : Array = []
		
		var limit: int = min(3, nodes.size())

		for i in range(limit):
			closest_nodes.append(nodes[i])

		# add to correct dictionary
		match curr_p.floor_num:
			1:
				floor_one_spots_near_paper[curr_index] = closest_nodes
			2:
				floor_two_spots_near_paper[curr_index] = closest_nodes
			3:
				floor_three_spots_near_paper[curr_index] = closest_nodes

		curr_index += 1
		
# this is whats called by movement manager
func get_random_spot(floorNum: int):

	var floor_spots : Dictionary[int, Array]

	match floorNum:
		1:
			floor_spots = floor_one_spots_near_paper
		2:
			floor_spots = floor_two_spots_near_paper
		3:
			floor_spots = floor_three_spots_near_paper

	# if nothing left on this floor
	if floor_spots.is_empty():
		return null

	# pick a valid paper key
	var random_paper_key = floor_spots.keys().pick_random()

	var picked_spot : Array = floor_spots[random_paper_key]

	# pick one of the nodes near that paper
	return picked_spot.pick_random()

func _handle_delete_paper_coords(paper_name) :
	var paper_index = paper_name_to_dic_index(paper_name)
	print('deleting: ', paper_name)
	
	if 1 <= paper_index and paper_index <= 3:
		floor_one_spots_near_paper.erase(paper_index)
	if 4 <= paper_index and paper_index <= 6 :
		floor_two_spots_near_paper.erase(paper_index)
	if 7 <= paper_index and paper_index <= 9 :
		floor_three_spots_near_paper.erase(paper_index)
	
	
	
