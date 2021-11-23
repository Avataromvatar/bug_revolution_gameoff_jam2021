extends Node

export var gol_scena_key:String = 'bug'
export var isAI:bool=false
export var hit:float = 10
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Actor.gol_scena_key = gol_scena_key
	set_AI(isAI)
	$Actor.connect("collision_event",self,'_collision_event')
	GlobalResource.game_data['bug_actor'] = $Actor
	GlobalResource.game_data['bug'] = self

func set_AI(on:bool):
	isAI=on
	$Actor.set_AI(on)
	$Actor.set_camera(!on)
	$Actor.set_light(!on)
	
func _collision_event(type:String,data):
	hit -=data
	if hit<=0:
		print(name,' DIE!')
	else:
		print(name,' DMG: ',data,' HIT:',hit)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
		
