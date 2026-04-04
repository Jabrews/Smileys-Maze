extends Control


func _ready() -> void:
	GlSignalBus.connect('exit_settings_btn_dwn', _handle_main_menu_exit_settings)
	
func _handle_main_menu_exit_settings()  :
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
