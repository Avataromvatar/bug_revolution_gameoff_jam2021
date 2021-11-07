extends AudioStreamPlayer2D

export var delay:float = 0.3 
export var sound_time:float = 0.182 
var curDelay:float = 0
var isPlay=false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	isPlay = true
	set_process(true)
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isPlay:
		if playing:
			curDelay+=delta
			if curDelay>=sound_time:
				stop()
				curDelay=0
		else:
			curDelay+=delta
			if curDelay>=delay:
				play()
				curDelay=0
	


func _on_AudioStreamPlayer2D_finished():
	#stream_paused = true
	#curDelay = 0
	pass
