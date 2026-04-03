extends AudioStreamPlayer3D 

var sound_active : bool = false

@onready var player_pos_check_timer = $"../../../PlayerPosCheck"




func _ready() -> void:
	connect('finished', _handle_sound_finished)
	player_pos_check_timer.connect('timeout', _on_player_pos_check_timeout)

# timer to check player pos
func _on_player_pos_check_timeout() -> void:
	
	# verify we can play song right now (not chase or end scene)	
	if get_parent().get_parent().get_parent().prevent_sound_playing == false :
	
		# if active parent
		if get_parent().get_parent().visible :
			# if sound active (decided by manager)
			if sound_active :
				# see if distance okay
				var valid_distance_check = get_player_pos()
				if valid_distance_check :
					# only play if not playing
					if not playing:
						play()

func get_player_pos() -> bool:
	var player : CharacterBody3D = get_parent().get_parent().get_parent().player
	var distance_squared = player.global_position.distance_squared_to(global_position)
	
	return distance_squared < 100
	
func _handle_sound_finished() :
	sound_active = false	
