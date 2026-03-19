extends Node

@export var ray : RayCast3D
@export var player : CharacterBody3D

func _process(_delta: float) -> void:
	
	# see if poking vent,
	if ray.is_colliding():
		var collider = ray.get_collider()
		
		# if poking vent 
		if collider.is_in_group("vents") :
			
			# and presses interact
			if Input.is_action_just_pressed("interact")	 :
				
				#for mini map
				var new_floor = collider.vent_floor
				if collider.vent_downward:
					new_floor -= 1
				else:
					new_floor += 1
				GlSignalBus.emit_signal("icon_changed_floor", player.name, 'PLAYER', player.global_position,  new_floor)
				GlSignalBus.emit_signal('player_changed_floor', new_floor)
				
				# activate vent_loading
				GlSignalBus.emit_signal('vent_loop_init', collider.vent_downward)
				GlSignalBus.emit_signal('vent_floor_travel', collider.vent_floor, collider.vent_downward)
