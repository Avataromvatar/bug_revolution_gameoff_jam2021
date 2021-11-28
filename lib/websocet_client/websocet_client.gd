extends Node

signal data_from_server(data)
signal closed()
signal connect_estabilished()

# The URL we will connect to
export var websocket_url = "ws://127.0.0.1:9081"

# Our WebSocketClient instance
var _client = WebSocketClient.new()
var isConnected:bool = false

func send_data(data:Dictionary):
	if isConnected:
		var d = to_json(data)
		_client.get_peer(1).put_packet(d.to_utf8())

func get_id():
	if isConnected:
		_client.get_connected_port()

func reconnect():
	print('Try to reconnect ',websocket_url)
	_client.disconnect("connection_closed", self, "_closed")
	_client.disconnect("connection_error", self, "_closed")
	_client.disconnect("connection_established", self, "_connected")
	_client.disconnect("data_received", self, "_on_data")
	isConnected = false
	_client.free()
	_client = WebSocketClient.new()
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")
	connect_to_server()

func _ready():
# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
# This signal is emitted when not using the Multiplayer API every time
# a full packet is received.
# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	_client.connect("data_received", self, "_on_data")
	#connect_to_server()
# Initiate connection to the given URL.
	

func connect_to_server(adress:String=''):
	if !isConnected:
		if adress.length()>3:
			websocket_url = adress
		print('Try to connect ',websocket_url)
		var err = _client.connect_to_url(websocket_url)
		if err != OK:
			print("Unable to connect err:",err)
			set_process(false)
		
	

func _closed(was_clean = false):
# was_clean will tell you if the disconnection was correctly notified
# by the remote peer before closing the socket.
	print("Closed ",websocket_url," clean: ", was_clean)
	set_process(false)
	isConnected = false
	emit_signal("closed")
	#connect_to_server()

func _connected(proto = ""):
# This is called on connection, "proto" will be the selected WebSocket
# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
# You MUST always use get_peer(1).put_packet to send data to server,
# and not put_packet directly when not using the MultiplayerAPI.
	#_client.get_peer(1).put_packet("Test packet".to_utf8())
	isConnected = true
	emit_signal("connect_estabilished")
	set_process(true)
		
func _on_data():
# Print the received packet, you MUST always use get_peer(1).get_packet
# to receive data from server, and not get_packet directly when not
# using the MultiplayerAPI.
	var ret =  _client.get_peer(1).get_packet().get_string_from_utf8()
	#print("Got data from server: ", ret)
	var json = parse_json(ret)
	if json is Dictionary:
		emit_signal("data_from_server",json)
	
	

func _process(delta):
# Call this in _process or _physics_process. Data transfer, and signals
# emission will only happen when calling this function.
	_client.poll()
