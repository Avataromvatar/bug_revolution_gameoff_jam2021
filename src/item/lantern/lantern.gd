extends Node2D

signal body_find(body)
signal body_hide(body)

export var gol_scena_key:String = 'lantern'
export var input_from_user:bool = false
export var energy:float = 1.5
var gol:GlobalObjectLogic

var isOn:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Light2D.energy = energy
	gol = GlobalObjectLogic.new()
	gol.gol_type = 'item'
	gol.gol_scena_key = gol_scena_key
	gol.event_handlers = {'update':funcref(self, '_event_handler_update')}
	add_child(gol)
	catch_input_from_user(input_from_user)

func catch_input_from_user(on:bool):
	input_from_user = on
	set_process_input(input_from_user)

func lantern_on(on:bool,need_emit:bool = false):
	if isOn != on:
		$Light2D.enabled =on
		isOn=on
		if need_emit:
			var tmp = gol.createAction('update',{'on':isOn})
			gol.gol_send_action(tmp)

func _event_handler_update(data:Dictionary):
	if data.has('on'):
		lantern_on(data['on'])
		

func _input(event):
	if Input.is_action_pressed("lantern"):
		if isOn:
			lantern_on(false,true)
		else:
			lantern_on(true,true)
				
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	emit_signal("body_find",body)


func _on_Area2D_body_exited(body):
	emit_signal("body_hide",body)
