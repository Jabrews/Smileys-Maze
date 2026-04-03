extends RayCast3D

var is_looking := false
var bossman_refrence : CharacterBody3D = null

@export var max_rotation : int = 25
var target_position_y : float = 0
@onready var cam_pivot : Node3D = $"../.."



func _ready() -> void:
	GlSignalBus.connect('bossman_intro_start', _handle_encounter_start)
	GlSignalBus.connect('bossman_killed', _handle_bossman_killed)

func _handle_encounter_start(bossman_char : CharacterBody3D) :
	bossman_refrence = bossman_char

func _handle_bossman_killed() :
	bossman_refrence = null
	

func _process(_delta: float) -> void:
		
	force_raycast_update()
		
	if not bossman_refrence :
		return
	
	else :
		rotate_raycast()

		var looking_now = is_colliding() and get_collider().is_in_group("bossman")
		if looking_now == false :
			pass

		if looking_now != is_looking:
			is_looking = looking_now
			GlSignalBus.emit_signal("player_looking_at_bossman", is_looking)

func rotate_raycast() -> void:
	if bossman_refrence == null:
		return
	
	var dir = bossman_refrence.global_position - global_position
	
	# y-only direction
	dir.y = 0.0
	
	if dir.length() == 0.0:
		return
	
	var target_y = atan2(-dir.x, -dir.z)
	var cam_y = cam_pivot.global_rotation.y
	
	# difference from camera to target
	var angle_diff = wrapf(target_y - cam_y, -PI, PI)
	
	# clamp so it only turns a little away from camera direction
	angle_diff = clamp(angle_diff, deg_to_rad(-25.0), deg_to_rad(25.0))
	
	global_rotation.y = cam_y + angle_diff
	
	
	
	
