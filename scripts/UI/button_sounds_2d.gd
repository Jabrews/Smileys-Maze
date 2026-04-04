extends Control 

@onready var s_hover_sound := $BtnHover
@onready var s_click_sound := $BtnClick
@onready var s_pause_sound := $BtnPaused

func _ready() -> void:
	GlSignalBus.connect('btn_hovered', _handle_play_hovered_sound)
	GlSignalBus.connect('btn_pressed', _handle_play_click_sound)
	GlSignalBus.connect('pause_btn_down', _handle_pause_btn_dwn)


func _handle_play_hovered_sound() :
	s_hover_sound.play()

func _handle_play_click_sound() :
	s_click_sound.play()

func _handle_pause_btn_dwn() :
	s_pause_sound.play()
