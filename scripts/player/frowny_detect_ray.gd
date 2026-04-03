extends RayCast3D 

func _ready() -> void:
	# for toggling off when smiley chase start
	GlSignalBus.connect('smiley_chase_intro_scene_start', _handle_intro_start)
	GlSignalBus.connect('smiley_chase_intro_scene_end', _handle_intro_end)



func _process(_delta: float) -> void:
	force_raycast_update()
	
	if is_colliding() and enabled:
		var collider = get_collider()
		if collider and collider.is_in_group("frowny"):
			var player = get_parent().get_parent().get_parent()
			
			GlSignalBus.emit_signal('player_seen_smiley', player.global_position)
	

func _handle_intro_start(_floor_num : int) :
	enabled = false

func _handle_intro_end() :
	enabled = true 
