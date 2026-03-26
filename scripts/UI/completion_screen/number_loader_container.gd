extends Node

@onready var time_number_label : Label = $TimeNumer
@onready var chase_number_label : Label = $ChaseNumber
@onready var retry_number_label : Label = $RetryNumber


func _ready() -> void:
	
	time_number_label.chosen_num = format_time(GlStats.total_time)
	time_number_label.roll_number()
	await time_number_label.loader_complete

	chase_number_label.chosen_num = str(GlStats.chases_encountered)
	chase_number_label.roll_number()
	await chase_number_label.loader_complete

	retry_number_label.chosen_num = str(GlStats.player_retries)
	retry_number_label.roll_number()
	await retry_number_label.loader_complete


func format_time(seconds: int) -> String:
	var minutes = seconds / 60
	var secs = seconds % 60
	
	return str(minutes) + "min " + str(secs) + "s"
