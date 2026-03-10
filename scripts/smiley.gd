extends Node3D

@onready var mini_map_update_timer : Timer = $MiniMapUpdateTimer


func _ready() -> void:
	GlSignalBus.emit_signal('map_icon_object_init','SMILEY', global_position, name)
	mini_map_update_timer.start()
		
func _process(delta: float) -> void:
	GlSignalBus.emit_signal('icon_moved', name, 'SMILEY', global_position)
	
	
	
	
