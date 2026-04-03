extends Node

# floor one
@onready var one_props_1 : GridMap = $FloorOne/GridMaps/OfficeProps1
@onready var one_props_2 : GridMap = $FloorOne/GridMaps/OfficeProps2
@onready var one_props_3 : GridMap = $FloorOne/GridMaps/OfficeProps3
@onready var one_props_cubbies : GridMap = $FloorOne/GridMaps/OfficeCubbys
@onready var one_break_room: GridMap = $FloorOne/GridMaps/BreakRoomProps

# floor two
@onready var two_props_1: GridMap = $FloorTwo/GridMaps/OfficeProps1
@onready var two_props_2 : GridMap = $FloorTwo/GridMaps/OfficeProps2
@onready var two_props_3 : GridMap = $FloorTwo/GridMaps/OfficeProps3
@onready var two_props_cubbies : GridMap = $FloorTwo/GridMaps/OfficeCubbys
@onready var two_break_room: GridMap = $FloorTwo/GridMaps/BreakRoomProps

# floor three
@onready var three_props_1: GridMap = $FloorThree/GridMaps/OfficeProps1
@onready var three_props_2 : GridMap = $FloorThree/GridMaps/OfficeProps2
@onready var three_props_3 : GridMap = $FloorThree/GridMaps/OfficeProps3
@onready var three_props_cubbies : GridMap = $FloorThree/GridMaps/OfficeCubbys
@onready var three_break_room: GridMap = $FloorThree/GridMaps/BreakRoomProps


# arrays for each floor
var floor_one_maps = []
var floor_two_maps = []
var floor_three_maps = []


func _ready() -> void:
	GlSignalBus.connect('player_changed_floor', _handle_player_changed_floor)

	floor_one_maps = [
		one_props_1, one_props_2, one_props_3,
		one_props_cubbies, one_break_room
	]

	floor_two_maps = [
		two_props_1, two_props_2, two_props_3,
		two_props_cubbies, two_break_room
	]

	floor_three_maps = [
		three_props_1, three_props_2, three_props_3,
		three_props_cubbies, three_break_room
	]


func _handle_player_changed_floor(new_floor_num : int):
	# hide everything first
	for grid in floor_one_maps:
		grid.visible = false
	for grid in floor_two_maps:
		grid.visible = false
	for grid in floor_three_maps:
		grid.visible = false

	# show current floor
	if new_floor_num == 1:
		for grid in floor_one_maps:
			grid.visible = true

	elif new_floor_num == 2:
		for grid in floor_two_maps:
			grid.visible = true

	elif new_floor_num == 3:
		for grid in floor_three_maps:
			grid.visible = true
