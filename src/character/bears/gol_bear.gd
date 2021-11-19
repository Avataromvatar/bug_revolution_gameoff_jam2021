extends Node

export var gol_scena_key:String = 'bear'
export var isAI:bool=true
export var hit:float = 5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var nav_2d:Navigation2D
var time_update_path:float = 10
var time_count:float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Actor.gol_scena_key = gol_scena_key
	set_AI(isAI)
	$Actor.connect("collision_event",self,'_collision_event')
	nav_2d = get_parent().find_node('Navigation2D')
	set_process(true)

func set_AI(on:bool):
	isAI=on
	$Actor.set_AI(on)
	#$Actor.set_camera(!on)
	#$Actor.set_light(!on)
	
func _collision_event(type:String,data):
	hit -=data
	if hit<=0:
		print(name,' DIE!')
	else:
		print(name,' DMG: ',data,' HIT:',hit)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_count +=delta
	if time_count>=time_update_path:
		time_count = 0
		if nav_2d != null:
			var gpb = $Actor.global_position
			var gps = GlobalResource.game_data['science'].global_position
			var path = nav_2d.get_simple_path(gpb,gps)
			$Actor.move_by_path(path)
			
			
			
			
