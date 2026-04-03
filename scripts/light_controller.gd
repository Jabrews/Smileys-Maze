extends Node

@export var default_floor_num : int = 1

# components
@export var FLOOR_ONE_LIGHT_PARENT: Node3D
@export var FLOOR_TWO_LIGHT_PARENT: Node3D
@export var FLOOR_THREE_LIGHT_PARENT: Node3D
@onready var chase_scene_blink_interval : Timer = $ChaseSceneBlinkInterval

# chase scene 
var chase_intro_beat : int = 0
var chase_light_node_parent : Node3D

func _ready() -> void:
	GlSignalBus.connect('light_area_travel', _on_light_area_travel)
	GlSignalBus.connect('vent_floor_travel', _on_vent_floor_travel )
	
	# handle smiley chase start flicker
	GlSignalBus.connect('smiley_chase_intro_scene_start', _handle_chase_start)
	
	# switch lights on/off accordingly.
	# also reset flickering 
	handle_lights_on(default_floor_num)
	# get light node and run flicker
	flicker_lights(default_floor_num)
	#GlSignalBus.connect('vent')


	

## area signal
func _on_light_area_travel(new_floor : int) :
	handle_lights_on(new_floor)
	flicker_lights(new_floor)


## vent signal		
func _on_vent_floor_travel(vent_floor : int, direction_down : bool) :
	
	var floor_number  = vent_floor
	
	# get correct floor number
	if direction_down :
		floor_number -= 1
	if not direction_down :
		floor_number += 1
	
	# func calls
	handle_lights_on(floor_number)
	flicker_lights(floor_number)

## helper func
func match_floor_for_node(new_floor : int) -> Node :
	
	var light_node
	
	match new_floor :
		1 :
			light_node = FLOOR_ONE_LIGHT_PARENT
		2 :
			light_node = FLOOR_TWO_LIGHT_PARENT
		3 :
			light_node = FLOOR_THREE_LIGHT_PARENT
	return light_node
	
	
## flicker random ceiling lights
func flicker_lights(floor_number : int) :
	# get children and par node
	var light_parent = match_floor_for_node(floor_number) #run helper
	var light_children = light_parent.get_children()
	
	#get two random items from children
	var random_index_one = randi() % light_children.size()
	var random_element_one = light_children[random_index_one]
	var random_index_two = randi() % light_children.size()
	var random_element_two = light_children[random_index_two]
	
	if random_element_one != null and random_element_one.has_method("set_can_blink"):
		await random_element_one.ready
		random_element_one.set_can_blink(true)

	if random_element_two != null and random_element_two.has_method("set_can_blink"):
		await random_element_one.ready
		random_element_two.set_can_blink(true)


	

## light turn on/off  && reseting flicker lights
func handle_lights_on(active_floor : int) :
	
	# get nodes
	var floor1Node = match_floor_for_node(1)
	var floor2Node = match_floor_for_node(2)
	var floor3Node = match_floor_for_node(3)
	
	match active_floor :
		1 :
			floor1Node.visible = true
			floor2Node.visible = false
			floor3Node.visible = false
			flicker_light_off(2)
			flicker_light_off(3)
		2 :
			floor1Node.visible = false
			floor2Node.visible = true
			floor3Node.visible = false
			flicker_light_off(1)
			flicker_light_off(3)
		3 :
			floor1Node.visible = false
			floor2Node.visible = false
			floor3Node.visible = true
			flicker_light_off(2)
			flicker_light_off(3)
		
func flicker_light_off(floor_number : int) :
	# get children and par node
	var light_parent = match_floor_for_node(floor_number)
	var light_children = light_parent.get_children()
	for light in light_children :
		if 'set_can_blink' in  light:
			light.set_can_blink(false)
		
		
### CHASE INTRO ####

func _handle_chase_start(floor_num: int):

	# get parent node
	chase_light_node_parent = match_floor_for_node(floor_num)

	chase_intro_beat = 1
	_update_chase_lights()
	chase_scene_blink_interval.start()


func _on_chase_scene_blink_interval_timeout() -> void:

	chase_intro_beat += 1

	_update_chase_lights()

	# stop after 6 beats
	if chase_intro_beat >= 6:

		GlSignalBus.emit_signal("smiley_chase_intro_scene_end")

		chase_scene_blink_interval.stop()
		chase_intro_beat = 0
		chase_light_node_parent = null


func _update_chase_lights():

	if chase_light_node_parent == null:
		return

	for light in chase_light_node_parent.get_children():
		if light.has_method("set_chase_scene_light_energy"):
			light.set_chase_scene_light_energy(chase_intro_beat)
