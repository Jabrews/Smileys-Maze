extends Node3D

@onready var settings : Control = $Settings

@onready var smiley_scene = "res://scenes/level_scenes/jump_scare_smiley.tscn"
@onready var frowny_scene = "res://scenes/level_scenes/jump_scare_frowny_2.tscn"
@onready var bossman_scene = "res://scenes/level_scenes/jump_scare_bossman.tscn"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlSignalBus.connect('smiley_caught_player', _handle_smiley_caught_player)
	GlSignalBus.connect('frowny_caught_player', _handle_frowny_caught_player)
	GlSignalBus.connect('bossman_caught_player', _handle_bossman_caught_player)
	
	GlSignalBus.connect('exit_settings_btn_dwn', _handle_settings_menu_btn_dwn)
	
func _process(delta: float) -> void: 
	if Input.is_action_just_pressed('settings') :
		GlSignalBus.emit_signal('pause_btn_down')
		settings.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true

func _handle_settings_menu_btn_dwn() :
	get_tree().paused = false 
	

func _handle_smiley_caught_player() :
	# change to jumpscare
	get_tree().change_scene_to_file(smiley_scene)
	
func _handle_frowny_caught_player() :
	get_tree().change_scene_to_file(frowny_scene)

func _handle_bossman_caught_player():
	get_tree().change_scene_to_file(bossman_scene)
	

func _on_time_in_level_timeout() -> void:
	GlStats.total_time += 1
