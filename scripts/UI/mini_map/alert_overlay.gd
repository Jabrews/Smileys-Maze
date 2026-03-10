extends CanvasModulate

@export var mini_map_controller : Control
@export var alert_lock_timer : Timer
var alert_lock = false

var smiley_seen = false 
var alert_time = 0.5
var alert_duration = 1.0

var shake_strength = 1
var base_pos : Vector2


func _ready() -> void:
	base_pos = mini_map_controller.position
	GlSignalBus.connect('smiley_appeared', _handle_smiley_appeared)
	GlSignalBus.connect('smiley_dissapeard', _handle_smiley_dissapeard)

func _handle_smiley_appeared() :
	smiley_seen = true

func _handle_smiley_dissapeard() :
	smiley_seen = false

func _process(delta):

	if smiley_seen and not alert_lock:
		start_alert()

	if alert_lock:
		update_alert(delta)
	else:
		reset_alert()


func start_alert():
	alert_lock = true
	alert_time = 0.0
	alert_lock_timer.start()
	GlSoundManager.emit_signal('smiley_alert')	


func update_alert(delta):

	alert_time += delta

	if alert_time < alert_duration:

		# shake minimap
		mini_map_controller.position = base_pos + Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)

		# flash red / black
		var flash = sin(Time.get_ticks_msec() * 0.04)

		if flash > 0:
			color = Color.BLACK
		else:
			color = Color.RED

	else:
		reset_alert()


func reset_alert():

	mini_map_controller.position = base_pos
	color = Color.WHITE
	modulate.a = 0.0


func _on_alert_lock_timer_timeout() -> void:
	alert_lock = false
