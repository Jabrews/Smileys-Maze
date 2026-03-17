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
var curr_spot_light_range : float = 13.0

# chase scene (store TRUE base values)
var org_spot_light_energy : float
var org_ceiling_light_energy : float


func _ready() -> void:
	GlLightingManager.connect("paper_collected", _handle_paper_collected)
	GlSignalBus.connect('smiley_chase_intro_scene_end', _handle_chase_intro_end)
	GlSignalBus.connect('smiley_chase_end', _handle_chase_end)

	# store ORIGINAL energy ONCE (critical fix)
	org_ceiling_light_energy = ceiling_light.light_energy
	org_spot_light_energy = spot_light.light_energy


func _handle_paper_collected() :
	var totalPapersCollected = GlLightingManager.totalPapersCollected
	
	match totalPapersCollected :
		1: 
			spot_light.spot_range = 13.0
			curr_spot_light_range = 13.0
		2: 
			spot_light.spot_range = 11.0
			curr_spot_light_range = 11.0
		3: 
			spot_light.spot_range = 9.0
			curr_spot_light_range = 9.0
		4: 
			spot_light.spot_range = 8.2
			curr_spot_light_range = 8.2
		5: 
			ceiling_light.omni_range = 5.0
			ceiling_light.omni_attenuation = 0.6


## setter for blink manager
func set_can_blink(value: bool) -> void:
	can_blink = value

	if can_blink and visible:
		blink_interval_timer.start()


## ONLY OCCURS ON BLINKING
func _on_blink_interval_timer_timeout() -> void:
	
	if light_on:
		spot_light.spot_range = curr_spot_light_range
		ceiling_light.omni_range = 10.0
		ceiling_light.omni_attenuation = 0.8
	else:
		spot_light.spot_range = 0.0
		ceiling_light.omni_range = 0.0
		ceiling_light.omni_attenuation = 0.0

	light_on = !light_on


## CHASE SCENE DRUM INTERVAL (FIXED)
func set_chase_scene_light_energy(beat: int):

	if beat >= 1 and beat <= 5:
		ceiling_light.light_color = Color.RED
		spot_light.light_color = Color.RED

		# NON-CUMULATIVE dimming (critical fix)
		ceiling_light.light_energy = org_ceiling_light_energy - (0.5 * beat)
		spot_light.light_energy = org_spot_light_energy - (2.0 * beat)

		# clamp to prevent negative values
		ceiling_light.light_energy = max(0.0, ceiling_light.light_energy)
		spot_light.light_energy = max(0.0, spot_light.light_energy)

	else:
		# restore clean state
		ceiling_light.light_color = Color.WHITE
		spot_light.light_color = Color.WHITE

		ceiling_light.light_energy = org_ceiling_light_energy
		spot_light.light_energy = org_spot_light_energy


func _handle_chase_intro_end():
	set_can_blink(true)


func _handle_chase_end():
	print('ceiling chase end')

	set_can_blink(false)
	blink_interval_timer.stop()

	# reset blink state
	light_on = true

	# restore ranges (critical for visibility)
	spot_light.spot_range = curr_spot_light_range
	ceiling_light.omni_range = 10.0
	ceiling_light.omni_attenuation = 0.8

	# restore colors
	ceiling_light.light_color = Color.WHITE
	spot_light.light_color = Color.WHITE

	# restore ORIGINAL energy (now reliable)
	ceiling_light.light_energy = org_ceiling_light_energy
	spot_light.light_energy = org_spot_light_energy
