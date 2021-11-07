extends Node2D

enum {
	CLOSED,
	SOUND_OPEN,
	SOUND_CLOSED,
	OPENED
}
export var state:int = CLOSED

func open():
	state = SOUND_OPEN
	$sound_open.play()

func close():
	state = SOUND_CLOSED
	$sound_closed.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	if state == OPENED:
		$closed.hide()
		$opened.show()
	else:
		$closed.show()
		$opened.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	open()
	

func _on_Area2D_body_exited(body):
	close()


func _on_AudioStreamPlayer2D_finished():
	pass # Replace with function body.


func _on_sound_closed_finished():
	$closed.show()
	$opened.hide()
	$closed/StaticBody2D/CollisionShape2D.set_deferred('disabled',false)
	state = CLOSED
	print('door open')


func _on_sound_open_finished():
	$closed.hide()
	$opened.show()
	$closed/StaticBody2D/CollisionShape2D.set_deferred('disabled',true)
	state = OPENED
	print('door closed')
