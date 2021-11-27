extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var light_default:bool = true
export var pulse:bool = false
export var time_pulse:float=1
export var alarm:bool = false 
export var speed_alarm:float = 1

var isLighting:bool = false

func on_light(on:bool):
	if on:
		$Light2D.show()
		isLighting = true
	else:
		$Light2D.hide()
		isLighting = false

func on_pulse(on:bool,time:float=1):
	time_pulse = time
	pulse = on
	if on:
		$Timer.stop()
		$Timer.start(time_pulse)
	else:
		$Timer.stop()
		

func on_alarm(on:bool,speed:float=1):
	alarm = on
	speed_alarm = speed
	$AudioStreamPlayer2D.pitch_scale = speed
	if on:
		$AudioStreamPlayer2D.play()
	else:
		$AudioStreamPlayer2D.stop()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	on_light(light_default)
	on_alarm(alarm,speed_alarm)
	on_pulse(pulse,time_pulse)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AudioStreamPlayer2D_finished():
	pass # Replace with function body.


func _on_Timer_timeout():
	if pulse:
		on_light(!isLighting)
		$Timer.start(time_pulse)
	else:
		on_light(light_default)
