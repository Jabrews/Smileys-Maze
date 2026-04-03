extends Area3D

@onready var bossman : CharacterBody3D = $".."


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('player') :
		if not bossman.being_looked_at :
			GlSignalBus.emit_signal('bossman_caught_player')
