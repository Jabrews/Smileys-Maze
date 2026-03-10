extends Node

## min distance required between the two real papers
@export var SPOT_DISTANCE_MIN: float = 100.0

## scene to spawn (paper scene must have 'is_dud' var)
@export var paper_scene: PackedScene

## available spots per floor (we copy these before modifying)
var FLOOR_ONE_SPOTS : Array [Vector3] = [
	Vector3(107.9, 4.0, -31.4),
	Vector3(55.64, 4.0, -33.4),
	Vector3(43, 3, 13),
	Vector3(50, 4, 33),
	Vector3(77, 4, 85),
	Vector3(77, 4, 107),
	Vector3(102, 4, 52),
	Vector3(70, 4, 68),
	Vector3(139, 4, 48),
]

var FLOOR_TWO_SPOTS : Array[Vector3] = [
	Vector3(83, 20, 34),
	Vector3(76, 20, 97),
	Vector3(53, 20, 97),
	Vector3(69, 20, 6),
	Vector3(70, 19, -14),
	Vector3(32, 19, -36),
	Vector3(25, 20, -38),
	Vector3(103, 20, 78),
]

var FLOOR_THREE_SPOTS  : Array[Vector3]= [
	Vector3(60, 37, 25),
	Vector3(81, 37, 25),
	Vector3(129, 37, -26),
	Vector3(125, 37, -14.2),
	Vector3(113, 37, -25.4),
	Vector3(12.55, 37, -32.5),
	Vector3(31.51, 37, -29.8),
	Vector3(8, 37, -5.90),
	Vector3(10.37, 36, 83),
	Vector3(33, 37, 64),
	Vector3(36, 37, 90),
	Vector3(118, 37, 87),
	Vector3(111.6, 37, 69.95),
	Vector3(130.6, 37, 63.93),
]

func _ready() -> void:
	randomize()

	# spawn papers for each floor using the same algorithm
	spawn_floor_papers(FLOOR_ONE_SPOTS)
	spawn_floor_papers(FLOOR_TWO_SPOTS)
	spawn_floor_papers(FLOOR_THREE_SPOTS)

## spawns 3 papers: paper1, paper2 (far from paper1), and a dud (any remaining spot)
func spawn_floor_papers(base_spots: Array[Vector3]) -> void:
	# copy so we can remove spots without affecting your originals
	var spots: Array[Vector3] = base_spots.duplicate()

	# choose paper1 + paper2 with restart logic if no valid distant spot exists
	var pair = pick_far_pair_with_restart(spots, SPOT_DISTANCE_MIN)
	var paper1: Vector3 = pair[0]
	var paper2: Vector3 = pair[1]

	# choose dud from remaining (if none left, just reuse paper1 as fallback)
	var dud: Vector3 = paper1
	if spots.size() > 0:
		dud = pop_random_spot(spots)

	create_papers_for_floor(paper1, paper2, dud)

## picks (spot1, spot2) where spot2 is at least min_dist away from spot1
## if a chosen spot1 has no valid far spot2, it "restarts" by putting spot1 back and trying a new spot1
func pick_far_pair_with_restart(spots: Array[Vector3], min_dist: float) -> Array[Vector3]:
	# safety: if not enough points, just return duplicates
	if spots.size() < 2:
		var only := spots[0] if spots.size() == 1 else Vector3.ZERO
		return [only, only]

	var attempts := 0
	var max_attempts := 200  # prevents infinite loops if your points are too clustered

	while attempts < max_attempts:
		attempts += 1

		# pick first spot and temporarily remove it from pool
		var spot1: Vector3 = pop_random_spot(spots)

		# try to find a distant second spot from remaining
		var spot2_opt = try_pop_distant_spot(spots, spot1, min_dist)

		if spot2_opt != null:
			# success: we removed both from spots already
			return [spot1, spot2_opt]

		# failure: put spot1 back and try again with a new spot1
		spots.append(spot1)

	# fallback: if we couldn't satisfy the distance rule, just pick any two
	var fallback1: Vector3 = pop_random_spot(spots)
	var fallback2: Vector3 = pop_random_spot(spots) if spots.size() > 0 else fallback1
	return [fallback1, fallback2]

## tries to find and remove a spot from 'spots' that is far enough from spot1
## returns the chosen Vector3, or null if none exist
func try_pop_distant_spot(spots: Array[Vector3], spot1: Vector3, min_dist: float) -> Variant:
	# scan indices that satisfy distance, then pick one randomly
	var valid_indices: Array[int] = []
	for i in range(spots.size()):
		if spot1.distance_to(spots[i]) > min_dist:
			valid_indices.append(i)

	if valid_indices.size() == 0:
		return null

	var pick_i: int = valid_indices[randi_range(0, valid_indices.size() - 1)]
	var chosen: Vector3 = spots[pick_i]
	spots.remove_at(pick_i)
	return chosen

## removes and returns a random spot from the array
func pop_random_spot(spots: Array[Vector3]) -> Vector3:
	var ran_index: int = randi_range(0, spots.size() - 1)
	var chosen: Vector3 = spots[ran_index]
	spots.remove_at(ran_index)
	return chosen

## spawns 3 paper scenes and positions them (paper_dud gets is_dud = true)
func create_papers_for_floor(paperOnePos: Vector3, paperTwoPos: Vector3, paperDudPos: Vector3) -> void:
	var paperOne = paper_scene.instantiate()
	add_child(paperOne)
	paperOne.name = "Paper"
	paperOne.global_position = paperOnePos

	var paperTwo = paper_scene.instantiate()
	add_child(paperTwo)
	paperTwo.name = 'Paper'
	paperTwo.global_position = paperTwoPos

	var paperDud = paper_scene.instantiate()
	add_child(paperDud)
	paperDud.name = 'Paper'
	paperDud.global_position = paperDudPos
	paperDud.is_dud = true
