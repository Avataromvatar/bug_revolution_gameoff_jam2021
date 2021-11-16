extends "res://lib/websocket_server/websocet_server.gd"

#var GOL_DTO = preload("res://lib/gol/gol_dto.gd")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect('new_data_from_client',self,'_new_data_from_client')
	

func _new_data_from_client(id,data_dict):
	#TODO: logic   
	var ret = GlobalObjectLogicDTO.new()
	ret = ret.fromDictionary(data_dict)
	if ret != null:
		if ret.target_key == ret.source and ret.action_name != 'update':
			send_data(id,ret.toJson())
		else:
			_send_to_another(id,ret.toJson())
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
