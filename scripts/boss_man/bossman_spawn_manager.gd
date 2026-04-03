extends Node

@export var player : CharacterBody3D

# floor nodes
@onready var floor_1_nodes : Node3D = $FloorOneNodes
@onready var floor_2_nodes : Node3D = $FloorTwoNodes
@onready var floor_3_nodes : Node3D = $FloorThreeNodes

# components
@onready var bossman_instance : PackedScene = preload("res://scenes/boss_man.tscn")
@onready var respawn_delay : Timer = $RespawnDelay

var total_papers_collected : int = 0

var curr_bossman : CharacterBody3D = null
var bossman_id_num : int = 0


func _ready() -> void:
	GlLightingManager.connect('paper_collected', _handle_paper_collected)
	GlSignalBus.connect('player_changed_floor', _handle_player_changed_floor)
	
	GlSignalBus.connect('respawn_bossman', _handle_respawn_bossman)
	
func spawn_bossman() :
	

	
	# get player floor num
	var playerFloorNum = GlSignalBus.player_floor_num
	
	# set bossman floor num to players
	GlSignalBus.bossman_floor_num = playerFloorNum
	GlSignalBus.emit_signal('bossman_changed_floor', playerFloorNum)
	
	var random_spot : Node3D
	match playerFloorNum:
		1:
			random_spot = get_closest_spot(floor_1_nodes)
		2:
			random_spot = get_closest_spot(floor_2_nodes)
		3:
			random_spot = get_closest_spot(floor_3_nodes)
	
	# spawn at correct spot	
	var bossman = bossman_instance.instantiate()
	bossman.player = player
	#bossman.name = "bossman_" + str(Time.get_ticks_msec())	
	bossman.name = 'boossman-' + str(bossman_id_num)
	curr_bossman = bossman
	get_tree().current_scene.add_child.call_deferred(bossman)
	#current_frowny = bossman
	bossman.set_deferred("global_position", random_spot.global_position)
	
	# for preventing frowny from spawning
	GlSignalBus.emit_signal('bossman_spawned')
	
	bossman_id_num += 1
	
	
func get_closest_spot(floor_nodes : Node3D) -> Node3D:
	var children_nodes = floor_nodes.get_children()
	
	if children_nodes.is_empty():
		return null
	
	var sorted_nodes = children_nodes.duplicate()
	
	sorted_nodes.sort_custom(func(a, b):
		return a.global_position.distance_to(player.global_position) < b.global_position.distance_to(player.global_position)
	)
	
	# smaller pool = closer spawn as papers increase
	
	return sorted_nodes[0]
	
	
func _handle_paper_collected() :
	total_papers_collected = GlLightingManager.totalPapersCollected
	
	# on new paper delete last frowny
	delete_bossman()
	
	if total_papers_collected == 3:
		spawn_bossman()
		
	if total_papers_collected == 5:
		spawn_bossman()
	
		
		
		
## DELETE		
		
func _handle_player_changed_floor(new_floor_num : int) :
	respawn_delay.stop()
	if curr_bossman : 
		if new_floor_num != GlSignalBus.bossman_floor_num :
			delete_bossman()
			respawn_delay.stop()
		
	
func delete_bossman() :
	respawn_delay.stop()
	if curr_bossman :
		GlSignalBus.emit_signal('bossman_killed')
		GlSignalBus.emit_signal('map_icon_delete', curr_bossman.name, curr_bossman.global_position)
		curr_bossman.queue_free()
		curr_bossman = null
	
## RESPAWN
func _handle_respawn_bossman() :
	GlSignalBus.emit_signal('bossman_killed')
	delete_bossman()
	respawn_delay.start()



func _on_respawn_delay_timeout() -> void:
	spawn_bossman()
