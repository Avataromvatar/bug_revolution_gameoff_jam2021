extends Node

signal new_data_from_client(id,data_dict)
signal client_connection(id)
signal client_disconnection(id)
# The port we will listen to
const PORT = 9081
# Our WebSocketServer instance
var _server = WebSocketServer.new()
var _clients:Dictionary
var isInit:bool = false
var isListen:bool = false
enum {
CONNECTED,
DISCONNECTED
}

func _close():
	print('Server close')
	_server.stop()

func listen():
	if isInit:
		var err = _server.listen(PORT)
		if err != OK:
			print("Unable to start server ERR:",err)
			set_process(false)
		print("WSocket Server listen OK! ")
		set_process(true)
		isListen = true	
	else:
		init()
		listen()
	
func _ready():
	if !isInit:
		self.connect("tree_exiting",self,'_close')
		set_process(false)
# Connect base signals to get notified of new client connections,
# disconnections, and disconnect requests.
		_server.connect("client_connected", self, "_connected")
		_server.connect("client_disconnected", self, "_disconnected")
		_server.connect("client_close_request", self, "_close_request")
# This signal is emitted when not using the Multiplayer API every time a
# full packet is received.
# Alternatively, you could check get_peer(PEER_ID).get_available_packets()
# in a loop for each connected peer.
		_server.connect("data_received", self, "_on_data")
		isInit = true
# Start listening on the given port.

func init():
	if !isInit:
		self.connect("tree_exiting",self,'_close')
		set_process(false)
# Connect base signals to get notified of new client connections,
# disconnections, and disconnect requests.
		_server.connect("client_connected", self, "_connected")
		_server.connect("client_disconnected", self, "_disconnected")
		_server.connect("client_close_request", self, "_close_request")
# This signal is emitted when not using the Multiplayer API every time a
# full packet is received.
# Alternatively, you could check get_peer(PEER_ID).get_available_packets()
# in a loop for each connected peer.
		_server.connect("data_received", self, "_on_data")
		isInit = true
		print("WSocket Server init OK! ")
# Start listening on the given port.

func _connected(id, proto):
# This is called when a new peer connects, "id" will be the assigned peer id,
# "proto" will be the selected WebSocket sub-protocol (which is optional)
	print("Client %d connected with protocol: %s" % [id, proto])
	_clients[id]={'state':CONNECTED,'protocol':proto}
	emit_signal("client_connection",id)

func _close_request(id, code, reason):
# This is called when a client notifies that it wishes to close the connection,
# providing a reason string and close code.
	print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])
	_clients[id]['state']=DISCONNECTED

func _disconnected(id, was_clean = false):
# This is called when a client disconnects, "id" will be the one of the
# disconnecting client, "was_clean" will tell you if the disconnection
# was correctly notified by the remote peer before closing the socket.
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])
	_clients.erase(id)
	emit_signal("client_disconnection",id)

func _on_data(id):
# Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
# and not get_packet directly when not using the MultiplayerAPI.
	var pkt = _server.get_peer(id).get_packet()
	var tmp = pkt.get_string_from_utf8()
	print("Got data from client %d: %s " % [id, tmp])
	var json = parse_json(tmp)
	if json is Dictionary:
		emit_signal("new_data_from_client",id,json)
		#_send_to_another(id,tmp)

##data - string
func send_data(to_id,data):
	for id in _clients.keys():
		if id == to_id:
			_server.get_peer(id).put_packet(data.to_utf8())

func _send_to_another(this_id,data):
	for id in _clients.keys():
		if id != this_id:
			_server.get_peer(id).put_packet(data.to_utf8())

func _process(delta):
# Call this in _process or _physics_process.
# Data transfer, and signals emission will only happen when calling this function.
	_server.poll()
