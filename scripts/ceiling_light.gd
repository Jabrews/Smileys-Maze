extends Node3D

# components
@onready var spot_light : SpotLight3D = $SpotLight3D
@onready var ceiling_light : OmniLight3D = $CeilingLight
@onready var blink_interval_timer : Timer = $BlinkIntervalTimer

# gets set randomly by blinkingLightManager
@export var floor_number : int = 1
var can_blink : bool = false
var light_on : bool = true

# curr spot light lvl (default 13)
var curr_spot_light_range : float = 13.00

func _ready() -> void:
	GlLightingManager.connect("paper_collected", _handle_paper_collected)


func _handle_paper_collected() :
	# get total papers
	var totalPapersCollected = GlLightingManager.totalPapersCollected
	# switch case for lighting values
	match totalPapersCollected :
		1 : 
			spot_light.spot_range= 13.000
			curr_spot_light_range = 13.000
		2 : 
			spot_light.spot_range = 11.000
			curr_spot_light_range = 11.000
		3 : 
			spot_light.spot_range = 9.000
			curr_spot_light_range = 9.00
		4 : 
			spot_light.spot_range = 8.200
			curr_spot_light_range = 8.200
		5 : 
			ceiling_light.omni_range = 5.0
			ceiling_light.omni_attenuation = 0.6
	
## setter for blink manager
func set_can_blink(value: bool) -> void:
	can_blink = value

	if can_blink && visible:
		blink_interval_timer.start()
		pass
	
## ONLY OCCURS ON BLINKING
func _on_blink_interval_timer_timeout() -> void:
	## ON
	if light_on :
		spot_light.spot_range = curr_spot_light_range
		ceiling_light.omni_range = 10.0
		ceiling_light.omni_attenuation = 0.8
	## OFF
	if not light_on:
		spot_light.spot_range = 0.0
		ceiling_light.omni_range = 0.0
		ceiling_light.omni_attenuation = 0.0
	#lastly flip
	light_on = !light_on
