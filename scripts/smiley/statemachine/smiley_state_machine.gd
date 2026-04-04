extends Node

@onready var idle_state : Node = $Idle
@onready var door_open_state : Node = $DoorOpen
@onready var chase_state : Node = $Chase

# SHARED VARS
@export var speed : float = 7.0
# change floor loop
var change_floor_speed_added : bool = false
var target_player_floor_num : int = 1


enum State {
	IDLE,
	DOOROPEN,
	CHASE
}

var states : Dictionary
var curr_state : Node


func _ready():
	# speed management to catch up with player floor
	GlSignalBus.connect('smiley_changed_floor', _handle_player_change_floor)
	GlSignalBus.connect('smiley_changed_floor', _handle_smiley_change_floor)
	# speed management with each paper
	GlLightingManager.connect('paper_collected', _handle_paper_collected)
	# lower speed when bossman active
	GlSignalBus.connect('bossman_spawned', _handle_bossman_spawned)
	GlSignalBus.connect('bossman_killed', _handle_bossman_killed)


	states = {
		State.IDLE: idle_state,
		State.DOOROPEN: door_open_state,
		State.CHASE: chase_state
	}

	switch_state(State.IDLE)


func switch_state(new_state : State):

	# exit previous state
	if curr_state and curr_state.has_method("state_end"):
		curr_state.state_end()

	# set new state
	curr_state = states[new_state]

	# start new state
	if curr_state.has_method("state_start"):
		curr_state.state_start()


func _process(delta):
	
	# always apply gravity
	if curr_state and curr_state.has_method("state_process"):
		curr_state.state_process(delta)


## SPEED MANAGEMENT

func _handle_player_change_floor(player_floor_num : int) :
	# speed up if floor diff
	if player_floor_num != get_parent().floor_num and not change_floor_speed_added:
		target_player_floor_num = player_floor_num
		change_floor_speed_added = true
		speed += 30
		print('change floor speed mode : ', speed)

func _handle_smiley_change_floor(smiley_floor_num : int) :
	if smiley_floor_num == target_player_floor_num and change_floor_speed_added:
		speed -= 30
		print('change floor speed mode return : ', speed)
		change_floor_speed_added = false

func _handle_paper_collected() :
	speed += 1.5
	print('up speed with paper : ', speed)
	
func _handle_bossman_spawned() :
	print('bossman_spawned ', speed)
	speed += -3
	
func _handle_bossman_killed() :
	speed += 3
	print('bossman_killed ', speed)
	
