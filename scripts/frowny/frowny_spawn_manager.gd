extends Node

@export var player : CharacterBody3D

# floor nodes
@onready var floor_1_nodes : Node3D = $FloorOneNodes
@onready var floor_2_nodes : Node3D = $FloorTwoNodes
@onready var floor_3_nodes : Node3D = $FloorThreeNodes

# components
@onready var frowny_instance : PackedScene = preload("res://scenes/frowny.tscn")
@onready var frowny_respawn_timer : Timer = $"../FrownyRespawnDelay"

# vars
var player_current_floor : int = 1
var total_papers_collected : int = 0
var frowny_ready_to_spawn : bool = true
var can_spawn_frowny : bool = true

# current spawned frowny
var current_frowny : Node3D = null

func _ready() -> void:
	# for spawning at correct time/place
	GlLightingManager.connect("paper_collected", _handle_paper_collected)
	GlSignalBus.connect("player_changed_floor", _handle_player_changed_floor)
	
	# frowny dies
	GlSignalBus.connect("frowny_deleted", _handle_frowny_deleted)
	
	# frowny prevent from spawing
	GlSignalBus.connect('bossman_spawned', _handle_bossman_spawned)
	GlSignalBus.connect('bossman_killed', _handle_bossman_killed)
	
	
	# respawning after timer
	frowny_respawn_timer.connect("timeout", _handle_frowny_respawn_timer)
	


func spawn_frowny() :
	if not can_spawn_frowny:
		return
	
	## DELETE PRIOR ##
	if current_frowny and is_instance_valid(current_frowny):
		
		# verify hes not in rush state (standing still)
		var horizontal_velocity = current_frowny.velocity
		horizontal_velocity.y = 0

		if horizontal_velocity.length() >= 0.05:
			frowny_respawn_timer.start()
			can_spawn_frowny = false
			return
		
		current_frowny.queue_free()
		current_frowny = null
	
	## GET SPOT ##
	var random_spot : Node3D
	
	match player_current_floor:
		1:
			random_spot = get_random_spot(floor_1_nodes)
		2:
			random_spot = get_random_spot(floor_2_nodes)
		3:
			random_spot = get_random_spot(floor_3_nodes)
	
	## SPAWN INSTANCE ##
	var frowny = frowny_instance.instantiate()
	get_tree().current_scene.add_child.call_deferred(frowny)
	current_frowny = frowny
	current_frowny.set_deferred("global_position", random_spot.global_position)
	
	can_spawn_frowny = false
	
	# every spawn restarts timer
	frowny_respawn_timer.stop()
	frowny_respawn_timer.start()


func get_random_spot(floor_nodes : Node3D) -> Node3D:
	var children_nodes = floor_nodes.get_children()

	if children_nodes.is_empty():
		return null

	var sorted_nodes = children_nodes.duplicate()

	sorted_nodes.sort_custom(func(a, b):
		return a.global_position.distance_to(player.global_position) < b.global_position.distance_to(player.global_position)
	)

	var candidate_count = get_spawn_candidate_count(sorted_nodes.size())

	# ensure we have at least 2 options before skipping closest
	if candidate_count > 1:
		var random_index = randi_range(1, candidate_count - 1) # skip index 0
		return sorted_nodes[random_index]
	else:
		# fallback if only 1 option exists
		return sorted_nodes[0]


func get_spawn_candidate_count(total_spots : int) -> int:
	if total_spots <= 1:
		return 1
	
	# papers 2 = wider range
	# more papers = tighter range near player
	if total_papers_collected <= 2:
		return max(1, int(total_spots * 0.6))
	elif total_papers_collected == 3:
		return max(1, int(total_spots * 0.4))
	elif total_papers_collected == 4:
		return max(1, int(total_spots * 0.25))
	else:
		return max(1, int(total_spots * 0.15))


############
## signal funcs
############
	
func _handle_paper_collected() :
	total_papers_collected = GlLightingManager.totalPapersCollected
	
	if total_papers_collected >= 2:
		can_spawn_frowny = true
		spawn_frowny()


func _handle_player_changed_floor(new_floor : int):
	player_current_floor = new_floor
	
	if total_papers_collected >= 2:
		can_spawn_frowny = true
		spawn_frowny()


func _handle_frowny_deleted() :
	current_frowny = null
	can_spawn_frowny = true
	
	if total_papers_collected >= 2:
		frowny_respawn_timer.stop()
		frowny_respawn_timer.start()


###########
## Timer
###########
		
func _handle_frowny_respawn_timer() :
	can_spawn_frowny = true
	spawn_frowny()

func _handle_bossman_spawned() :
	can_spawn_frowny = false
	frowny_respawn_timer.stop()
	if current_frowny :
		current_frowny.queue_free()
		current_frowny = null

func _handle_bossman_killed():
	can_spawn_frowny = true
	frowny_respawn_timer.start()
