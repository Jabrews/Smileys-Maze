extends StaticBody3D

@export var vent_downward = false	
@export var vent_floor = 0

# notice : vent entering logic occurs on players ray cast

# components
@onready var hoverable_mesh := $hoverable_mesh
var down_arrow_bouncing_sprite_scene : PackedScene = preload("res://scenes/hover_bouncing_sprites/arrow_down_sprite.tscn")


func _ready() -> void:
	
	await get_tree().process_frame
	if vent_downward :
		GlSignalBus.emit_signal("map_icon_object_init", 'VENT-DOWN', global_position, name)
	if not vent_downward :
		GlSignalBus.emit_signal("map_icon_object_init", 'VENT-UP',global_position, name)
	
	# setting proper bouncing sprite
	if vent_downward :
		hoverable_mesh.bouncing_sprite_scene  = down_arrow_bouncing_sprite_scene
		

		
