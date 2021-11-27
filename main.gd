extends Control

var POP_WARNING = preload("res://src/popup/warning/warning.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var server_start=false
var _ws_adress:String =''
var _ws_port:String =''
# Called when the node enters the scene tree for the first time.
func _ready():
	if !GlobalResource.game_data.has('isServer'):
		GlobalResource.game_data['isServer'] = false
		server_start = false
	else:
		$server_start.text = 'Stop Server'
	_ws_adress = $ws_adress.text
	_ws_port = $ws_port.text
	GlobalResource.game_data['pop_warning'] = $warning



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_connect_science_pressed():
	GolMaster.connect_to_server(_ws_adress+':'+_ws_port)
	GlobalResource.game_data['player_type'] = 'science'
	get_tree().change_scene("res://src/scena/mission_intro/state1/state1.tscn") # Replace with function body.


func _on_connect_bug_pressed():
	GolMaster.connect_to_server(_ws_adress+':'+_ws_port)
	GlobalResource.game_data['player_type'] = 'bug'
	get_tree().change_scene("res://src/scena/mission_intro/state1/state1.tscn")


func _on_server_start_pressed():
	if !server_start:	
		var p = int(_ws_port)
		if p!=0 and p>0:
			GolServer.listen(p)
			server_start = true
			GlobalResource.game_data['isServer'] = true
			$server_start.text = 'Stop Server'
		else:
			printerr('WebSocket PORT SET ERROR ',p)
			$server_start.text = 'Repeat start'
		


func _on_connect_solder_pressed():
	GolMaster.connect_to_server(_ws_adress+':'+_ws_port)
	GlobalResource.game_data['player_type'] = 'solder'
	get_tree().change_scene("res://src/scena/mission_intro/gol_mission_intro.tscn")



func _on_ws_adress_text_entered(new_text):
	_ws_adress = $ws_adress.text
	GlobalResource.game_data['pop_warning'].add_warning(_ws_adress)


func _on_ws_port_text_entered(new_text):
	_ws_port = $ws_port.text
	GlobalResource.game_data['pop_warning'].add_warning(_ws_port)
