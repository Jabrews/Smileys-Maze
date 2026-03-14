extends Node

### Smiley will chase player and open door if looking at it. 
### check gl_signal_bus


@export var node_active : bool = false
@onready var nav_agent : NavigationAgent3D = $"../NavigationAgent3D"
@onready var smiley : CharacterBody3D = $'../../'
@export var player : CharacterBody3D 

### DOOR LOGIC
var can_open_door : bool = false
var reachable_door_pos = Vector3.ZERO

# MOVEABLE NODE LOGIC
@export var smiley_move_nodes : Node
var curr_target : Node3D


func _ready() -> void:
	nav_agent.connect('navigation_finished', _handle_nav_finished)
	
	if not node_active:
		self.queue_free()
	
	# door	
	GlSignalBus.connect('toggle_smiley_in_door_radius', _handle_toggle_smiley_in_door_radius)	
	
	
func _physics_process(_delta: float) -> void:
	
	# if not node found
	if not curr_target :
		curr_target = get_random_location()
	else :
		nav_agent.set_target_position(curr_target.global_position)	
		
		var dest = nav_agent.get_next_path_position()
		var local_dest =  dest - smiley.global_position
		var direction = local_dest.normalized()
		
		# smiley direction
		var look_pos = dest
		look_pos.y = smiley.global_position.y
		smiley.look_at(look_pos, Vector3.UP)	
		
		smiley.velocity = direction * 5.0
		smiley.move_and_slide()
	
##### node idle helpers#####	
func get_random_location() :
	
	var smiley_move_children = smiley_move_nodes.get_children()
	
	## get random num
	var max_index = len(smiley_move_children)
	var random_index = randi_range(0, max_index)
	
	return smiley_move_children[random_index]
	

func _handle_nav_finished() :
	curr_target = null
	smiley.velocity = Vector3.ZERO
	nav_agent.set_target_position(Vector3.ZERO)	



func _process(_delta: float) -> void:
	
	if can_open_door and reachable_door_pos != Vector3.ZERO:
		
		var dir_to_door = (reachable_door_pos - smiley.global_position).normalized()
		var smiley_forward = -smiley.global_transform.basis.z
		
		# dot product tells how aligned the directions are
		var alignment = dir_to_door.dot(smiley_forward)
		
		# OPEN DOOR
		if alignment > 0.5:
			GlSignalBus.emit_signal('smiley_open_door')			
			can_open_door = false
			reachable_door_pos = Vector3.ZERO

func _handle_toggle_smiley_in_door_radius(toggleValue: bool, door_pos: Vector3):
	print('toggle : ', toggleValue, ' door pos  : ', door_pos)
	can_open_door = toggleValue
	reachable_door_pos = door_pos
