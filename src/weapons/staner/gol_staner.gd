extends Node2D
export var gol_scena_key:String = 'staner'
export var speed:float = 10
export var begin_scale:Vector2 = Vector2(0.2,0.2)
export var end_scale:Vector2 = Vector2(1,1)
export var speed_rotate:float = 10
export var distance:float =50

var Net = preload("res://src/weapons/staner/net.tscn")
var net
var isColddown:bool = false
var isSend:bool = false
var timer_test
var gol:GlobalObjectLogic
# Called when the node enters the scene tree for the first time.
func _ready():
	#timer_test = Timer.new()
	#timer_test.autostart = true
	#timer_test.wait_time = 5
	#timer_test.connect("timeout", self, "_timeout")
	#add_child(timer_test)
	gol = GlobalObjectLogic.new()
	gol.gol_type = 'item'
	gol.event_handlers = {'shoot':funcref(self, '_event_handler_shoot')}
	#set_process_input(true)
	#for test
	#GolServer.listen()
	#GolMaster.connect_to_server()
	add_child(gol)

func catch_input_from_user(on:bool):
	set_process_input(false)

func need_shoot():
	
	if !isSend and !isColddown:
		isSend = true
		print('need_shoot to',get_global_mouse_position())
		var v = get_global_mouse_position()
		var tmp = gol.createAction('shoot',{'target_gl_position_X':v.x,'target_gl_position_Y':v.y})
		gol.gol_send_action(tmp)

func _event_handler_shoot(data:Dictionary):
	isSend = false
	var glpos
	if data.has('target_gl_position_X') and data.has('target_gl_position_Y') :
		glpos = Vector2(data['target_gl_position_X'],data['target_gl_position_Y'])
		if !isColddown:
			net = Net.instance()
			net.speed = speed
			net.begin_scale = begin_scale
			net.end_scale = end_scale
			net.speed_rotate = speed_rotate
			net.distance = distance
			net.init(global_position,glpos)
			net.connect('move_end',self,'_move_end')
			net.connect('target_hit',self,'_target_hit')
			get_tree().root.add_child(net)
			isColddown = true
			print('shoot to',glpos)
	else:
		printerr('ERROR GOL EVENT shoot in gol_staner data:',data)
	

func _input(event):
	if Input.is_action_pressed("fire"):
		need_shoot()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _move_end():
	
	if net!=null:
		if net.is_inside_tree():
			#get_tree().root.remove_child(net)
			isColddown = false
			net.queue_free()
	
func _target_hit(body):
	#var arr = area.get_overlapping_bodies() as Array
	#if area.overlaps_body(GlobalResource.game_data['ai_actor_node'] ):
	print('I HIT BUG ? ',body.name)
	net.queue_free()
	isColddown = false
	
	#if !arr.empty():
	#	for i in arr:
	#		#if i is ActorKinematicBody2D:
	#		print('I HIT ',i.name)
	#		if i.name == 'Bug':
	#			print('I HIT BUG')
	#if net!=null:
	#	if net.is_inside_tree():
	#		net.queue_free()
	#		#get_tree().root.remove_child(net)
	#		isColddown = false
	#		#net.queue_free()

#func _timeout():
#	shoot()
