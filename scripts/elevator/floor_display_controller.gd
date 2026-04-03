extends Node

@onready var Label_One : Label3D = $Label1
@onready var Label_Two : Label3D = $Label2

@export var max_floor_num : int = 8
@export var min_floor_num : int = 1
@export var increment_up_timer : Timer 
@export var increment_down_timer : Timer 

var current_floor_num : int = 1

func _ready() -> void: 
	if GlStats.retry_loop_active :
		current_floor_num = 7
# UP
func increment_floor_up() :
	increment_down_timer.stop()
	increment_up_timer.start()
	
# increment up
func _on_increment_up_timeout() -> void:
	# if reach target
	if current_floor_num == max_floor_num :
		GlSignalBus.emit_signal('elevator_arrived')
		increment_up_timer.stop()
	# else increment
	else : 
		current_floor_num += 1
		update_label_text()
		increment_up_timer.start()



func update_label_text(): 
	Label_One.text = str(current_floor_num)
	Label_Two.text = str(current_floor_num)
	

# DOWN
func increment_floor_down() :
	increment_down_timer.start()
	increment_up_timer.stop()	
	

func _on_increment_down_timeout() -> void:
	# if reach target
	if current_floor_num == min_floor_num:
		increment_down_timer.stop()
	# else decremet 
	else : 
		current_floor_num -= 1
		update_label_text()
		increment_down_timer.start()
