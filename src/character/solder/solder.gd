extends Node

export var gol_scena_key:String = 'solder' setget gol_scena_key_change
export var isAI:bool=false
export var hit:float = 10

export var inServer:bool = true
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_item:int =0
var items:Array
var gol:GlobalObjectLogic
var isSend:bool = false
var nav_2d:Navigation2D
var time_count:float = 0
var ai_work_time_count:float = 0


var ai_state = 0 # 0 -search 1- find and att 2-poterial
var ai_rand0 = 1000
var ai_rand1 = 50
var ai_rand2 = 200
var ai_count_state2 = 0
# Called when the node enters the scene tree for the first time.

func gol_scena_key_change(scena_key:String):
	gol_scena_key = scena_key
	$Actor.gol_scena_key = gol_scena_key+'_actor'
	$Actor/Lantern.gol_scena_key = gol_scena_key+'_lantern'
	$Actor/autorifle.gol_scena_key = gol_scena_key+'_autogun'
	if gol != null:
		gol.gol_scena_key = scena_key

func _ready():
	gol = GlobalObjectLogic.new()
	gol.gol_scena_key = gol_scena_key
	gol.gol_type = 'character'
	gol.event_handlers = {'next_item':funcref(self, '_event_handler_next_item')}
	nav_2d = get_parent().find_node('Navigation2D')
	$Actor.gol_scena_key = gol_scena_key+'_actor'
	$Actor/Lantern.gol_scena_key = gol_scena_key+'_lantern'
	$Actor/autorifle.gol_scena_key = gol_scena_key+'_autogun'
	
	$Actor/Lantern.connect("body_find",self,'_body_find')
	$Actor/Lantern.connect("body_hide",self,'_body_hide')
	$Actor.connect("collision_event",self,'_collision_event')
	#$Actor.connect("actor_state_change",self,'_actor_change_state')
	set_AI(isAI)
	GlobalResource.game_data[$Actor.gol_scena_key] = $Actor
	GlobalResource.game_data[gol_scena_key] = self
	add_child(gol)

func _process(delta):
	time_count +=delta
	if time_count>0.1:
		time_count=0
		if $Actor.state == 0 or $Actor.state == 3:
			$Actor/AnimatedSprite.play('idle')
		if $Actor.state == 1 or $Actor.state == 2:
			if $Actor.isWalk:
				$Actor/AnimatedSprite.play('move')
			else:
				$Actor/AnimatedSprite.play('idle')
	if isAI:
		ai_work_time_count+=delta
		if ai_work_time_count>=1:
			ai_work_time_count = 0
			if nav_2d != null:
				var r
				if ai_state == 0: #search bug
					r = ai_rand0
				if ai_state == 1: #find bug and try hit
					r = ai_rand1
					$Actor/autorifle.need_shoot(GlobalResource.game_data['bug_actor'].global_position)
				if ai_state == 2: #bug hide
					r = ai_rand2
					ai_count_state2+=1
					if ai_count_state2>5:
						ai_state=0
				else:
					ai_count_state2=0
				var randX = (randi() % r + 1)-r/2	# random integer between 1 and 512.
				var randY = (randi() % r + 1)-r/2	# random integer between 1 and 512.
				var gpb = $Actor.global_position
				var gps = GlobalResource.game_data['bug_actor'].global_position
				var path = nav_2d.get_simple_path(gpb,Vector2(gps.x+randX,gps.y+randY))
				#print('SCIENC NAVI ',path)
				$Actor.move_by_path(path)

func set_AI(on:bool):
	isAI=on
	$Actor.set_AI(on)
	$Actor.set_camera(!on)
	if isAI:
		randomize()
		$Actor/Lantern.catch_input_from_user(false)
		$Actor/autorifle.catch_input_from_user(false)
		
	else:
		$Actor/Lantern.catch_input_from_user(true)
		$Actor/autorifle.catch_input_from_user(true)

func add_item(item:String):
	pass

func remove_item(item:String):
	pass

func next_item():
	pass


#func _input(event):
#	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _body_find(body):
	if isAI and body == GlobalResource.game_data['bug_actor']:
		ai_state = 1
		print('I find you!!!')

func _body_hide(body):
	if isAI and body == GlobalResource.game_data['bug_actor']:
		ai_state = 2
		print('You not hide at me!!!')

func _collision_event(type:String,data):
	$Actor/AnimatedSprite.play('hit')
	hit -=data
	if hit<=0:
		print(name,' DIE!')
	else:
		print(name,' DMG: ',data,' HIT:',hit)
