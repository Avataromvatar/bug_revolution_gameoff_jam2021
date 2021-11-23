extends Node

export var gol_scena_key:String = 'science'
export var isAI:bool=false
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
# Called when the node enters the scene tree for the first time.
func _ready():
	gol = GlobalObjectLogic.new()
	gol.gol_scena_key = gol_scena_key
	gol.gol_type = 'character'
	gol.event_handlers = {'next_item':funcref(self, '_event_handler_next_item')}
	nav_2d = get_parent().find_node('Navigation2D')
	$Actor.gol_scena_key = gol_scena_key+'_actor'
	$Actor/Lantern.gol_scena_key = gol_scena_key+'_lantern'
	$Actor/laser_gun.gol_scena_key = gol_scena_key+'_laser_gun'
	$Actor/laser_gun.hide()
	#$Actor.connect("actor_state_change",self,'_actor_change_state')
	set_AI(isAI)
	GlobalResource.game_data['science_actor'] = $Actor
	GlobalResource.game_data['science'] = self
	add_child(gol)

func _process(delta):
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
	if isAI:
		ai_work_time_count+=delta
		if ai_work_time_count>=3:
			ai_work_time_count = 0
			if nav_2d != null:
				var gpb = $Actor.global_position
				var gps = GlobalResource.game_data['bug'].global_position
				var path = nav_2d.get_simple_path(gpb,gps)
				$Actor.move_by_path(path)
		

func set_AI(on:bool):
	isAI=on
	$Actor.set_AI(on)
	$Actor.set_camera(!on)
	$Actor/Staner.catch_input_from_user(!on)
	if isAI:
		$Actor/Lantern.catch_input_from_user(false)
		$Actor/laser_gun.catch_input_from_user(false)
		$Actor/Light2D.hide()
	else:
		if current_item==0:
			$Actor/Lantern.catch_input_from_user(true)
			$Actor/laser_gun.catch_input_from_user(false)
		else:
			$Actor/Lantern.catch_input_from_user(false)
			$Actor/laser_gun.catch_input_from_user(true)
	set_process_input(!on)

func add_item(item:String):
	pass

func remove_item(item:String):
	pass

func next_item():
	pass

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
