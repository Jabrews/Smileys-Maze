extends Control

@onready var death_screen_1 : AnimatedSprite2D = $DeathScreen1
@onready var death_screen_2 : AnimatedSprite2D = $DeathScreen2
@onready var death_screen_3 : AnimatedSprite2D = $DeathScreen3


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	var curr_screen = GlSignalBus.curr_death_screen
	
	match curr_screen:
		1:
			death_screen_1.visible = true
			death_screen_2.visible = false
			death_screen_3.visible = false
		2:
			death_screen_1.visible = false
			death_screen_2.visible = true
			death_screen_3.visible = false
		3:
			death_screen_1.visible = false
			death_screen_2.visible = false
			death_screen_3.visible = true
	
	# increment + loop
	curr_screen += 1
	if curr_screen > 3:
		curr_screen = 1
	
	GlSignalBus.curr_death_screen = curr_screen
