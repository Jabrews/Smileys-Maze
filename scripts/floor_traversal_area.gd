extends Area3D 

@export var enter_floor_num = 0


func _ready() -> void:
	body_entered.connect(_on_floor_area_body_entered)
	
	
func _on_floor_area_body_entered(body : Node3D) :
	if body.is_in_group('player') :
		
		GlSignalBus.emit_signal('player_changed_floor', enter_floor_num)
		GlSignalBus.player_floor_num = enter_floor_num
		# light area controller
		GlSignalBus.emit_signal("light_area_travel", enter_floor_num)
		# mini map
		GlSignalBus.emit_signal("icon_changed_floor", body.name, 'PLAYER', body.global_position, enter_floor_num)
		
		
	if body.is_in_group('smiley') :
		GlSignalBus.emit_signal('smiley_changed_floor', enter_floor_num)
		GlSignalBus.smiley_floor_num = enter_floor_num
		# mini map
		GlSignalBus.emit_signal("icon_changed_floor", body.name, 'SMILEY', body.global_position, enter_floor_num)
	
	if body.is_in_group('bossman') :
		GlSignalBus.emit_signal('bossman_changed_floor', enter_floor_num)
		GlSignalBus.emit_signal("icon_changed_floor", body.name, 'BOSSMAN', body.global_position, enter_floor_num)
		GlSignalBus.bossman_floor_num = enter_floor_num
		
		
		
