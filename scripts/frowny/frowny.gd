extends CharacterBody3D

@onready var player_detect_area: Area3D = $PlayerDetectArea 

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta


func _on_player_detect_area_body_entered(body: Node3D) -> void:
	if body.is_in_group('player') :
		GlSignalBus.emit_signal('frowny_caught_player')
		player_detect_area.monitoring = false
