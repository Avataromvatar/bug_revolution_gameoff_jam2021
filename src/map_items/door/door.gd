extends Node2D

enum {
	CLOSED,
	SOUND_OPEN,
	SOUND_CLOSED,
	OPENED
}
export var state:int = CLOSED
export var gol_scena_key:String = 'door'

var gol:GlobalObjectLogic

func open():
	state = SOUND_OPEN
	_update()
	$sound_open.play()

func close():
	state = SOUND_CLOSED
	_update()
	$sound_closed.play()

func _update():
	var tmp = gol.createAction('update',{'state':state})
	gol.gol_send_action(tmp)
# Called when the node enters the scene tree for the first time.
func _ready():
	if state == OPENED:
		$closed.hide()
		$opened.show()
	else:
		$closed.show()
		$opened.hide()
	gol = GlobalObjectLogic.new()
	gol.gol_type = 'door'
	gol.event_handlers = {'update':funcref(self, '_event_handler_update')}
	#for test
	#GolServer.listen()
	#GolMaster.connect_to_server()
	add_child(gol)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _event_handler_update(data:Dictionary):
	if data.has('state') :
		if data['state']==SOUND_OPEN:
			open()
		if data['state']==SOUND_CLOSED:
			close()
	else:
		printerr('ERROR GOL EVENT update in gol_door data:',data)

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
	print('door closed')


func _on_sound_open_finished():
	$closed.hide()
	$opened.show()
	$closed/StaticBody2D/CollisionShape2D.set_deferred('disabled',true)
	state = OPENED
	print('door open')
