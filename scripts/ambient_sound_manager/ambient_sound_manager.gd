extends Node

@export var player : CharacterBody3D 

# floor nodes
@export var FloorOne : Node3D
@export var FloorTwo : Node3D
@export var FloorThree : Node3D

var last_floor_node : Node3D

func _ready() -> void:
	GlSignalBus.connect('player_changed_floor', _handle_change_sound_floor)
	
	# set last for when changing
	last_floor_node = FloorOne
	
	pick_active_sounds(FloorOne)
	


func _handle_change_sound_floor(new_floor : int) :
	
	unpick_active_sounds(last_floor_node)	
	
	# get new floor
	var chose_floor_node : Node3D
	match new_floor :
		1 :
			chose_floor_node = FloorOne
		2 : 
			chose_floor_node = FloorTwo
		3 :
			chose_floor_node = FloorThree
		
	# pick sounds
	pick_active_sounds(chose_floor_node)
	
	# set last floor
	last_floor_node = chose_floor_node

func pick_active_sounds(floor_parent : Node3D):
	for children_node in floor_parent.get_children():
		
		var sound_streams = children_node.get_children()
		
		if sound_streams.size() == 0:
			continue
		
		sound_streams.shuffle()
		
		# always pick first
		var random_sound_one : AudioStreamPlayer3D = sound_streams[0]
		random_sound_one.sound_active = true
		
		#if this group is ToiletFlush, stop here
		if children_node.name == "ToiletFlush":
			continue
		
		# otherwise pick second if exists
		if sound_streams.size() > 1:
			var random_sound_two : AudioStreamPlayer3D = sound_streams[1]
			random_sound_two.sound_active = true
		
func unpick_active_sounds(floor_parent : Node3D) :
		for children_node in floor_parent.get_children():
			for sound_node in children_node.get_children() :
				sound_node.	sound_active = false		
			
			
