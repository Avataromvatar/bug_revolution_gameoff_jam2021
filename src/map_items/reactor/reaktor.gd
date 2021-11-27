extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
	$Timer.start(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()


func _on_Timer_timeout():
	if $Light2D.is_visible_in_tree():
		$Light2D.hide()
	else:
		$Light2D.show()
	
