extends Node

export var gol_scena_key:String = 'science' setget gol_scena_key_change
export var isAI:bool=false
export var hit:float = 10
export var geager_on:bool = false
export var melee_stun = 10
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

var isSlave:bool = false
var isServer:bool = false

var geager_power:float = 0
var geager_count:float = 0

var geager_sound_on:bool = false

var ai_state = 0 # 0 -search 1- find and att 2-poterial
var ai_rand0 = 1000
var ai_rand1 = 50
var ai_rand2 = 200
var ai_count_state2 = 0

var _time_cheburec:float =5
var _time_cheburec_count:float=0
# Called when the node enters the scene tree for the first time.

func gol_scena_key_change(scena_key:String):
	gol_scena_key = scena_key
	$Actor.gol_scena_key = gol_scena_key+'_actor'
	$Actor/Lantern.gol_scena_key = gol_scena_key+'_lantern'
	$Actor/autorifle.gol_scena_key = gol_scena_key+'_laser_gun'
	if gol != null:
		gol.gol_scena_key = scena_key

func _ready():
	randomize()
	if GlobalResource.game_data['isServer']:
		isSlave = false
		isServer = true
	gol = GlobalObjectLogic.new()
	gol.gol_scena_key = gol_scena_key
	gol.gol_type = 'character'
	gol.event_handlers = {'next_item':funcref(self, '_event_handler_next_item'),
	'playerConnect':funcref(self, '_event_playerConnect')}
	nav_2d = get_parent().find_node('Navigation2D')
	$Actor.gol_scena_key = gol_scena_key+'_actor'
	$Actor/Lantern.gol_scena_key = gol_scena_key+'_lantern'
	$Actor/laser_gun.gol_scena_key = gol_scena_key+'_laser_gun'
	$Actor/laser_gun.hide()
	$Actor/Lantern.connect("body_find",self,'_body_find')
	$Actor/Lantern.connect("body_hide",self,'_body_hide')
	$Actor.connect("collision_event",self,'_collision_event')
	#$Actor.connect("actor_state_change",self,'_actor_change_state')
	set_AI(isAI)
	GlobalResource.game_data['science_actor'] = $Actor
	GlobalResource.game_data['science'] = self
	
	add_child(gol)

func _process(delta):
	if isServer:
		_time_cheburec_count +=delta
		if _time_cheburec_count>_time_cheburec:
			_time_cheburec_count = 0
			_time_cheburec = (randi() % 20 + 1)
			var randX = (randi() % 200 + 1)-100/2	# random integer between 1 and 512.
			var randY = (randi() % 200 + 1)-100/2	# random integer between 1 and 512.
			var gscena = find_parent('SCENA')
			var act = gol.createActionTo('scena',gscena.gol_scena_key,'add',{'type':'cheburec','positionX':$Actor.global_position.x+randX,'positionY':$Actor.global_position.y+randY})
			gol.gol_send_action(act)
			#GlobalResource.game_data['pop_warning'].add_warning('cheburek add') 
	time_count +=delta
	if time_count>0.1:
		time_count=0
		if $Actor.state == 0 or $Actor.state == 3:
			$Actor/AnimatedSprite.play('idle')
			$Actor/AnimatedSprite/AnimationPlayer.play("idle")
		if $Actor.state == 1 or $Actor.state == 2:
			if $Actor.isWalk:
				$Actor/AnimatedSprite.play('move')
			else:
				$Actor/AnimatedSprite.play('idle')
				$Actor/AnimatedSprite/AnimationPlayer.play("idle")
			$Actor/AnimatedSprite/AnimationPlayer.play("RESET")
	if isAI and !isSlave:
		ai_work_time_count+=delta
		if ai_work_time_count>=1:
			ai_work_time_count = 0
			if nav_2d != null:
				var r
				if ai_state == 0: #search bug
					r = ai_rand0
				if ai_state == 1: #find bug and try hit
					r = ai_rand1
					$Actor/Staner.need_shoot(GlobalResource.game_data['bug_actor'].global_position)
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
	if geager_on:
		geager_count +=delta
		if geager_count>0.5:
			geager_count=0
			var v:Vector2 = GlobalResource.game_data['bug_actor'].global_position - $Actor.global_position
			geager_power = 2000 - v.length()
			if geager_power > 0:
				$Actor/AudioStreamPlayer2D.volume_db = 0.5 + geager_power/120
				$Actor/AudioStreamPlayer2D.pitch_scale = 0.2+geager_power/1000
				if !geager_sound_on:
					$Actor/AudioStreamPlayer2D.play()
					geager_sound_on =true
			else:
				geager_sound_on =false

func set_AI(on:bool):
	isAI=on
	$Actor.set_AI(on)
	$Actor.set_camera(!on)
	$Actor/Staner.catch_input_from_user(!on)
	if isAI:
		geager_on = false
		$Actor/Lantern.catch_input_from_user(false)
		$Actor/laser_gun.catch_input_from_user(false)
		$Actor/Staner.catch_input_from_user(false)
		$Actor/Light2D.hide()
	else:
		$Actor/Lantern.catch_input_from_user(true)
		if current_item==0:
			$Actor/Staner.catch_input_from_user(true)
			$Actor/laser_gun.catch_input_from_user(false)
		else:
			$Actor/Staner.catch_input_from_user(false)
			$Actor/laser_gun.catch_input_from_user(true)
	if gol!=null and !isServer and !isAI:
		#GlobalResource.game_data['players']['science']=true
		var a = gol.createAction('playerConnect',{'on':!isAI})
		gol.gol_send_action(a)
	set_process_input(!on)

func add_item(item:String):
	pass

func remove_item(item:String):
	pass

func next_item():
	pass

func _event_playerConnect(data:Dictionary):
	if data.has('on'):
		print(gol_scena_key,' PlayerConnect ',data['on'])
		set_AI(data['on'])
		isSlave = data['on']
		
func _event_handler_next_item(data:Dictionary):
	isSend = false
	if data.has('item'):
		if data['item']==1:
			$Actor/Staner.hide()
			$Actor/laser_gun.show()
			if !isAI:
				$Actor/Staner.catch_input_from_user(false)
				$Actor/laser_gun.catch_input_from_user(true)
		if data['item']==0:
			$Actor/Staner.show()
			$Actor/laser_gun.hide()
			if !isAI:
				$Actor/Staner.catch_input_from_user(true)
				$Actor/laser_gun.catch_input_from_user(false)
				
			

func _input(event):
	if Input.is_action_pressed("next_item") and !isSend:
		isSend = true
		if current_item==0:
			current_item =1
		else:
			current_item =0
		var tmp = gol.createAction('next_item',{'item':current_item})
		gol.gol_send_action(tmp)
		
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
	if type=='dmg':
		hit -=data
		if hit<=0:
			print(name,' DIE!')
		else:
			print(name,' DMG: ',data,' HIT:',hit)

func _on_AudioStreamPlayer2D_finished():
	if geager_sound_on and geager_on:
		$Actor/AudioStreamPlayer2D.play()


func _on_MeleeFightArea_body_entered(body):
	if body.has_method('collisionEvent'):
		body.collisionEvent('stun',melee_stun)
	
