extends Node

signal new_data_from_server(data)

var Client = preload("res://lib/websocet_client/websocet_client.gd")
var client

export var isClientOn:bool = false
export var type:String = "bug"
var actorIsChanged:bool = false
var timer

var data:Dictionary


func set_state(state):
	$Actor.state = state

func set_position(pos:Vector2):
	$Actor.position = pos

func set_rotate(rotate:float):
	$Actor.rotation = rotate
	
func set_stamina(stamina:float):
	$Actor.stamina=stamina


func _timeout():
	if actorIsChanged:
		client.send_data(data)
		actorIsChanged = false
# Called when the node enters the scene tree for the first time.
func _ready():
	print('BUG is Ready ',isClientOn)
	if isClientOn:
		client = Client.new()
		client.connect("data_from_server",self,'_on_client_new_data')
		add_child(client)
		timer = Timer.new()
		timer.autostart = true
		timer.wait_time = 0.1
		timer.connect("timeout", self, "_timeout")
		add_child(timer)
	else:
		$Actor/Camera2D.current = false
		$Actor.isAI = true
	data={'type':type,'state':$Actor.state,'pos_x':$Actor.position.x,'pos_y':$Actor.position.y,'rotation':$Actor.rotation,'stamina':$Actor.stamina}
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_client_new_data(data):
	emit_signal("new_data_from_server",data)

func _on_Actor_actor_state_change(state):
	data['state'] = state
	actorIsChanged = true

func _on_Actor_position_change(position, rotate):
	data['pos_x'] = position.x
	data['pos_y'] = position.y
	data['rotation'] = rotate
	actorIsChanged = true


func _on_Actor_stamina_change(stamina):
	data['stamina'] = stamina
	actorIsChanged = true
