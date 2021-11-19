extends Node

#action from GOL go up to the GOL master and up to the client websocket to server
#From server in client websocket go event/ Event fall down to the GOL Master and to the target gol 


var Client = preload("res://lib/websocet_client/websocet_client.gd")
var client


# key:type value:Dictionary
## value:Dictionary key=gol_scena_key value=GlobalObjectLogic
var _gol:Dictionary = {}

func isConnected()->bool:
	return client.isConnected()

func reconnect():
	client.reconnect()
func connect_to_server():
	client.connect_to_server()

# Called when the node enters the scene tree for the first time.
func _ready():
	client = Client.new()
	client.connect("data_from_server",self,'_on_client_new_data')
	add_child(client)

func addGOL(gol:GlobalObjectLogic)->bool:
	if !_gol.has(gol.gol_type):
		_gol[gol.gol_type]={gol.gol_scena_key:gol}
		return true
	else:
		if !_gol[gol.gol_type].has(gol.gol_scena_key):
			_gol[gol.gol_type][gol.gol_scena_key] = gol
			return true
	return false

func removeGOL(gol:GlobalObjectLogic):
	if !_gol.has(gol.gol_type):
		if !_gol[gol.gol_type].has(gol.gol_scena_key):
			_gol[gol.gol_type].erase(gol.gol_scena_key)

func gol_send_action(action):
	client.send_data(action.getDictionary())

func gol_set_event(event):
	if _gol.has(event.target_type):
		if _gol[event.target_type].has(event.target_key):
			_gol[event.target_type][event.target_key].gol_set_event(event)

#data - Dictionary
func _on_client_new_data(data):
	var tmp = GlobalObjectLogicDTO.new()
	tmp = tmp.fromDictionary(data)
	if tmp != null:
		if tmp.action_name!='move':
			print('Client ',client.get_id(),' DTO:',data)
		gol_set_event(tmp)
