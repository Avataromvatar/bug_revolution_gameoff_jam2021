extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalResource.game_data['isServer'] = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_connect_science_pressed():
	GolMaster.connect_to_server()
	GlobalResource.game_data['player_type'] = 'science'
	get_tree().change_scene("res://src/scena/mission_intro/gol_mission_intro.tscn") # Replace with function body.


func _on_connect_bug_pressed():
	GolMaster.connect_to_server()
	GlobalResource.game_data['player_type'] = 'bug'
	get_tree().change_scene("res://src/scena/mission_intro/gol_mission_intro.tscn")


func _on_server_start_pressed():
	GlobalResource.game_data['isServer'] = true
	GolServer.listen()
