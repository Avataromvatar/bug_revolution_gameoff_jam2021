extends "res://lib/websocket_server/websocet_server.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect('new_data_from_client',self,'_new_data_from_client')
	init()
	listen()
	pass # Replace with function body.

func _new_data_from_client(id,data_dict):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
