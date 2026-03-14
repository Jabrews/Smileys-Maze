extends Node

@export var default_floor_num : int = 1

@export var FLOOR_ONE_LIGHT_PARENT: Node3D  
@export var FLOOR_TWO_LIGHT_PARENT: Node3D 
@export var FLOOR_THREE_LIGHT_PARENT: Node3D 

func _ready() -> void:
	GlSignalBus.connect('light_area_travel', _on_light_area_travel)
	GlSignalBus.connect('vent_floor_travel', _on_vent_floor_travel )
	
	
	# switch lights on/off accordingly.
	# also reset flickering 
	handle_lights_on(default_floor_num)
	# get light node and run flicker
	flicker_lights(default_floor_num)
	

## area signal
func _on_light_area_travel(floor : int) :
	handle_lights_on(floor)
	flicker_lights(floor)


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
func match_floor_for_node(floor : int) -> Node :
	
	var light_node 
	
	match floor :
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
	
	
	
	
