extends Node

export var gol_scena_key:String = 'science'
export var isAI:bool=false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Actor.gol_scena_key = gol_scena_key
	$Actor/Lantern.gol_scena_key = 'lantern'
	set_AI(isAI)
	GlobalResource.game_data['science'] = $Actor

func set_AI(on:bool):
	isAI=on
	$Actor.set_AI(on)
	$Actor.set_camera(!on)
	$Actor/Staner.catch_input_from_user(!on)
	$Actor/Lantern.catch_input_from_user(!on)
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass