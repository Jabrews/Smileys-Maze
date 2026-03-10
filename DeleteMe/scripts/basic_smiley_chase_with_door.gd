extends Node

### Smiley will chase player and open door if looking at it. 
# check gl_signal_bus


@export var node_active : bool = false
@onready var nav_agent : NavigationAgent3D = $"../NavigationAgent3D"
@onready var smiley : CharacterBody3D = $".."
@onready var player : CharacterBody3D = $"../../Player"

func _ready() -> void:
	nav_agent.connect('navigation_finished', _handle_nav_finished)
	
	# door	
	
	
	
func _physics_process(delta: float) -> void:
	nav_agent.set_target_position(player.global_position)	
	
	var dest = nav_agent.get_next_path_position()
	var local_dest =  dest - smiley.global_position
	var direction = local_dest.normalized()
	
	# smiley direction
	if not player.global_position.is_equal_approx(smiley.global_position):
		smiley.look_at(player.global_position, Vector3.UP)
	
	smiley.velocity = direction * 5.0
	smiley.move_and_slide()

func _handle_nav_finished() :
	smiley.velocity = Vector3.ZERO
	nav_agent.set_target_position(Vector3.ZERO)	


	
	
