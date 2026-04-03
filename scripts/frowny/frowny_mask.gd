extends RigidBody3D

@onready var delete_timer : Timer = $DeleteTimer

func _ready() -> void:
	delete_timer.connect('timeout', _handle_delete_timer_timeout)

func _handle_delete_timer_timeout() :
	queue_free()
