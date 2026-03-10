extends Node

### THIS SCRIPT JUST REPRESENTS A SIMPLE MOVEMENT USING NAVMESH. PRESS 'SPACE' to init


@export var node_active : bool = false
@onready var nav_agent : NavigationAgent3D = $"../NavigationAgent3D"
@onready var smiley : CharacterBody3D = $".."

func _ready() -> void:
	nav_agent.connect('navigation_finished', _handle_nav_finished)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_accept') :
		var random_pos := Vector3.ZERO
		random_pos.x = randf_range(-10.0, 10.0) 
		random_pos.z = randf_range(-10.0, 10.0)
		nav_agent.set_target_position(random_pos)
		
		
func _physics_process(delta: float) -> void:
	var dest = nav_agent.get_next_path_position()
	var local_dest =  dest - smiley.global_position
	var direction = local_dest.normalized()
	

	
	# smiley direction
	if not dest.is_equal_approx(smiley.global_position):
		smiley.look_at(dest, Vector3.UP)
	
	smiley.velocity = direction * 5.0
	smiley.move_and_slide()

func _handle_nav_finished() :
	smiley.velocity = Vector3.ZERO
	nav_agent.set_target_position(Vector3.ZERO)	


	
	
