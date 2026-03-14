extends Node

@onready var nav_agent : NavigationAgent3D = $"../../NavigationAgent3D"
@onready var smiley : CharacterBody3D = $"../.."
@export var player : CharacterBody3D

### DOOR LOGIC
var can_open_door : bool = false
var reachable_door_pos = Vector3.ZERO

# MOVEABLE NODE LOGIC
@export var smiley_move_nodes : Node
var curr_target : Node3D

### DELETE DOOR TESTING ###
@export var door_pos_node : Node3D



func _ready() -> void:
	nav_agent.connect('navigation_finished', _handle_nav_finished)
	# door in radius
	GlSignalBus.connect('toggle_smiley_in_door_radius', _handle_toggle_smiley_in_door_radius)
	
	
# main loop for smiley moving to location
func _physics_process(_delta: float) -> void:
	
	# if target is missing or freed, get a new one
	if curr_target == null or not is_instance_valid(curr_target):
		curr_target = get_random_location()
		smiley.velocity = Vector3.ZERO
		return
	
	nav_agent.set_target_position(curr_target.global_position)

	var dest = nav_agent.get_next_path_position()
	var direction = dest - smiley.global_position
	direction.y = 0

	# only move / rotate if there is enough distance
	if direction.length() > 0.05:
		direction = direction.normalized()

		# handle where smiley is rotated
		var look_pos = dest
		look_pos.y = smiley.global_position.y

		if not smiley.global_position.is_equal_approx(look_pos):
			smiley.look_at(look_pos, Vector3.UP)

		smiley.velocity.x = direction.x * 10.0
		smiley.velocity.z = direction.z * 10.0
	else:
		smiley.velocity.x = 0.0
		smiley.velocity.z = 0.0

	smiley.move_and_slide()
	
##### node idle helpers#####	
func get_random_location() :
	
	## DELETE TESTING ##
	return door_pos_node
	
	#var smiley_move_children = smiley_move_nodes.get_children()
	#
	### get random num
	#var max_index = len(smiley_move_children ) - 1
	#var random_index = randi_range(0, max_index)
	#
	#return smiley_move_children[random_index]
	

func _handle_nav_finished() :
	curr_target = null
	smiley.velocity = Vector3.ZERO
	nav_agent.set_target_position(Vector3.ZERO)


## SWITCHING TO DOOR STATE

func _process(_delta: float) -> void:
	
	if can_open_door and reachable_door_pos != Vector3.ZERO:
		
		var dir_to_door = (reachable_door_pos - smiley.global_position).normalized()
		var smiley_forward = -smiley.global_transform.basis.z
		
		# dot product tells how aligned the directions are
		var alignment = dir_to_door.dot(smiley_forward)
		
		# OPEN DOOR
		if alignment > 0.2:
			can_open_door = false
			reachable_door_pos = Vector3.ZERO

func _handle_toggle_smiley_in_door_radius(toggleValue: bool, door_pos: Vector3):
	can_open_door = toggleValue
	reachable_door_pos = door_pos
