extends Area3D

const light_types := ['table', 'ceiling', 'stairwell']

@onready var sound_light_bleep_red = $LightBleepRed

# for naming timers
var light_parent_name 

## Main Signals
func _on_body_entered(body: Node3D) -> void:
	# verify body is of type of light node
	var lightType = body.get_meta('light_type')	
	if light_types.has(lightType) :
		light_parent_name = body.name
		handle_turn_red(lightType, body)
###
	
### HANDLERS (calls helpers) 
func handle_turn_red(lightType, body) :
	match lightType :
		'table' :
			var lightNodes = get_table_light_nodes(body)
			flash_lights_red(lightNodes)	
		'ceiling' :
			var lightNodes = get_ceiling_light_nodes(body)
			flash_lights_red(lightNodes)	
		'stairwell' :
			var lightNodes =  get_stairwell_light_nodes(body)
			flash_lights_red(lightNodes)	
	
### helpers 
func get_ceiling_light_nodes(body : Node3D) :
	var block_light : OmniLight3D = body.get_node('BlockLight')		
	var spot_light : SpotLight3D = body.get_node('SpotLight3D')
	var ceiling_light : OmniLight3D = body.get_node('CeilingLight')
	var lightNodes = [block_light, spot_light, ceiling_light]
	return lightNodes
	
func get_stairwell_light_nodes(body : Node3D) :
	var	block_light : OmniLight3D = body.get_node('BlockLight')
	var lightNodes = [block_light]
	return lightNodes

func get_table_light_nodes(body : Node3D) :
	var block_light = body.get_node('BlockLight')
	var table_light = body.get_node('TableLight')
	var lightNodes = [block_light, table_light]
	return lightNodes

###

func flash_lights_red(lightNodes):
	
		## create timer node
		var new_timer_name = 'timer-' + light_parent_name
		# 1. create timer instance
		var timer := Timer.new()
		# 2. configure it
		timer.name = new_timer_name
		timer.wait_time = 1.5
		timer.one_shot = true
		timer.autostart = false
		# 3. connect signal (optional but recommended)
		timer.timeout.connect(_on_light_timer_timeout.bind(lightNodes, timer))
		# 4. add to scene tree
		add_child(timer)
		
		## turn lights red	and play sound
		for lightNode in lightNodes :
			lightNode.light_color = Color.RED
			# play sound
			sound_light_bleep_red.play()
		
		# 5. start it
		timer.start()

## turn back to white
func _on_light_timer_timeout(lightNodes, timer) :
	for lightNode in lightNodes :
		lightNode.light_color = Color.WHITE
	timer.queue_free()
