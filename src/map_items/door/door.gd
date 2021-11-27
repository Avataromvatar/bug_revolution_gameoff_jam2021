extends Node2D

enum {
	CLOSED,
	SOUND_OPEN,
	SOUND_CLOSED,
	OPENED
}
export var block_on:bool = false
export var state:int = CLOSED
export var gol_scena_key:String = 'door'
var electric_error:bool = false
var eclectric_error_light_pulse = 0.4
var gol:GlobalObjectLogic

func open(need_update:bool = false):
	if !block_on:
		state = SOUND_OPEN
		if need_update:
			_update()
		$sound_open.play()

func close(need_update:bool = false):
	state = SOUND_CLOSED
	if need_update:
		_update()
	$sound_closed.play()

func _update():
	var tmp = gol.createAction('update',{'state':state})
	gol.gol_send_action(tmp)
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$tmr_electric.start((randi() % 200 + 1))
	if state == OPENED:
		$closed.hide()
		$opened.show()
	else:
		$closed.show()
		$opened.hide()
	gol = GlobalObjectLogic.new()
	gol.gol_type = 'door'
	gol.gol_scena_key = gol_scena_key
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
	if body is KinematicBody2D:
		open(true)
	

func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
		close(true)


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


func _on_tmr_electric_timeout():
	electric_error = true
	$tmr_light.start(eclectric_error_light_pulse)
	$electric_shock.play()


func _on_tmr_light_timeout():
	if electric_error:
		var r = randi()%2
		if r ==0:
			if $closed/StaticBody2D/Light2D.is_visible_in_tree():
				$closed/StaticBody2D/Light2D.hide()
			else:
				$closed/StaticBody2D/Light2D.show()
		else:
			if $closed/StaticBody2D/Light2D2.is_visible_in_tree():
				$closed/StaticBody2D/Light2D2.hide()
			else:
				$closed/StaticBody2D/Light2D2.show()
		$tmr_light.start(eclectric_error_light_pulse)
	else:
		$closed/StaticBody2D/Light2D.show()
		$closed/StaticBody2D/Light2D2.show()


func _on_electric_shock_finished():
	electric_error = false
	$tmr_electric.start((randi() % 10 + 1))
