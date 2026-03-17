extends Node

@onready var idle_state : Node = $Idle
@onready var door_open_state : Node = $DoorOpen
@onready var chase_state : Node = $Chase

# SHARED VARS
@export var speed : float = 8.0


enum State {
	IDLE,
	DOOROPEN,
	CHASE
}

var states : Dictionary
var curr_state : Node


func _ready():

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
