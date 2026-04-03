extends CharacterBody3D 

@onready var mini_map_update_timer : Timer = $MiniMapUpdateTimer

@export var floor_num : int 


func _ready() -> void:
	await get_tree().process_frame
	GlSignalBus.emit_signal('map_icon_object_init','SMILEY', global_position, name)
	mini_map_update_timer.start()
	
	# update floor_num	
	GlSignalBus.connect('smiley_changed_floor', _handle_smiley_change_floor)
	
	
func _on_mini_map_update_timer_timeout() -> void:
	GlSignalBus.emit_signal('icon_moved', name, 'SMILEY', global_position)

func _process(delta: float) -> void:
	if not is_on_floor() : 
		velocity += get_gravity() * delta

func _handle_smiley_change_floor(new_floor_num : int) :
	floor_num = new_floor_num


func _on_catch_area_body_entered(body: Node3D) -> void:
	if body.is_in_group('player') :
		GlSignalBus.emit_signal('smiley_caught_player')
