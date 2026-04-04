extends CanvasLayer


func _ready() -> void:
	GlSignalBus.connect('pause_btn_down', _handle_open_settings)
	GlSignalBus.connect('exit_settings_btn_dwn', _handle_exit_settings_)


func _handle_open_settings() :
	visible = false


func _handle_exit_settings_() :
	visible = true 
