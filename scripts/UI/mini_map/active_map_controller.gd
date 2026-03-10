extends Node

@export var active_floor : int = 1

@onready var map_one_node : Control = $"../MapFloorOne"
@onready var map_one_sprite_dark : Sprite2D = $"../MapFloorOne/MapDark"
@onready var map_one_sprite_light : Sprite2D = $"../MapFloorOne/MapLight"

@onready var map_two_node : Control = $"../MapFloorTwo"
@onready var map_two_sprite_dark : Sprite2D = $"../MapFloorTwo/MapDark"
@onready var map_two_sprite_light : Sprite2D = $"../MapFloorTwo/MapLight"

@onready var map_three_node : Control = $"../MapFloorThree"
@onready var map_three_sprite_dark : Sprite2D = $"../MapFloorThree/MapDark"
@onready var map_three_sprite_light : Sprite2D = $"../MapFloorThree/MapLight"


func _ready() -> void:
	GlSignalBus.connect("light_area_travel", _on_player_floor_change)
	GlSignalBus.connect("vent_floor_travel", _on_player_vent_floor_change)


## signals for actice floor ####
func _on_player_floor_change(floor : int) :
	if floor == active_floor:
		return
	
	active_floor = floor
	await render_active_floors_map()


func _on_player_vent_floor_change(vent_floor : int, direction_down : bool) :
	if direction_down:
		active_floor = vent_floor - 1
	else:
		active_floor = vent_floor + 1
	
	await render_active_floors_map()
###################################


######### MAIN FUNC CALL #####
func render_active_floors_map():

	match active_floor:

		1:
			await dissolve_map(map_two_sprite_dark, map_two_sprite_light)
			await dissolve_map(map_three_sprite_dark, map_three_sprite_light)

			hide_maps(map_two_node, map_three_node)

			await establish_map(map_one_sprite_dark, map_one_sprite_light, map_one_node)

		2:
			await dissolve_map(map_one_sprite_dark, map_one_sprite_light)
			await dissolve_map(map_three_sprite_dark, map_three_sprite_light)

			hide_maps(map_one_node, map_three_node)

			await establish_map(map_two_sprite_dark, map_two_sprite_light, map_two_node)

		3:
			await dissolve_map(map_one_sprite_dark, map_one_sprite_light)
			await dissolve_map(map_two_sprite_dark, map_two_sprite_light)

			hide_maps(map_one_node, map_two_node)

			await establish_map(map_three_sprite_dark, map_three_sprite_light, map_three_node)

################# MAP DISSOLVING ##############


# dissolve maps (fade out)
func dissolve_map(map_dark : Sprite2D, map_light : Sprite2D):

	var tween = create_tween()

	# dark map
	tween.tween_property(
		map_dark.material,
		"shader_parameter/dissolve_amount",
		1.0,
		1
	)

	# light map
	tween.parallel().tween_property(
		map_light.material,
		"shader_parameter/dissolve_amount",
		1.0,
		1
	)

	# light map children (icons)
	for child in map_light.get_children():
		if child is Sprite2D and child.material:
			tween.parallel().tween_property(
				child.material,
				"shader_parameter/dissolve_amount",
				1.0,
				1
			)

	await tween.finished


# make map appear
func establish_map(map_dark : Sprite2D, map_light : Sprite2D, map_control_node: Control):

	map_control_node.visible = true
	
	# start fully dissolved
	map_dark.material.set_shader_parameter("dissolve_amount", 1.0)
	map_light.material.set_shader_parameter("dissolve_amount", 1.0)

	for child in map_light.get_children():
		if child is Sprite2D and child.material:
			child.material.set_shader_parameter("dissolve_amount", 1.0)

	var tween = create_tween()

	# dark map
	tween.tween_property(
		map_dark.material,
		"shader_parameter/dissolve_amount",
		0.0,
		1
	)

	# light map
	tween.parallel().tween_property(
		map_light.material,
		"shader_parameter/dissolve_amount",
		0.0,
		1
	)

	# icons
	for child in map_light.get_children():
		if child is Sprite2D and child.material:
			tween.parallel().tween_property(
				child.material,
				"shader_parameter/dissolve_amount",
				0.0,
				1
			)


func hide_maps(map_node_one: Control, map_node_two: Control):

	map_node_one.visible = false

	if map_node_two:
		map_node_two.visible = false
