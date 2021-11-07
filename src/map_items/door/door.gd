extends Node2D

enum {
	CLOSED,
	OPENED
}
export var state:int = CLOSED

func open():
	$closed.hide()
	$opened.show()
	$closed/StaticBody2D/CollisionShape2D.set_deferred('disabled',true)
	state = OPENED

func close():
	$closed.show()
	$opened.hide()
	$closed/StaticBody2D/CollisionShape2D.set_deferred('disabled',false)
	state = CLOSED

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
