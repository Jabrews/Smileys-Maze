extends Node

@onready var smiley_alert_sound : AudioStreamPlayer3D = $SmileyAlert
@onready var paper_alert_sound : AudioStreamPlayer3D = $PaperSeen

@onready var paper_seen_delay_timer : Timer = $PaperSeen/PaperSeenDelay
var paper_seen_locked : bool = false


func _ready() -> void:
	GlSoundManager.connect('smiley_alert', _play_smiley_alert)
	GlSoundManager.connect('paper_alert', _play_paper_alert)


func _play_smiley_alert() : 
	smiley_alert_sound.play()

func _play_paper_alert() :
	if paper_seen_locked : return
	else :
		paper_alert_sound.play()	
		paper_seen_delay_timer.start()
		paper_seen_locked = true


func _on_paper_seen_delay_timeout() -> void:
	paper_seen_locked = false
