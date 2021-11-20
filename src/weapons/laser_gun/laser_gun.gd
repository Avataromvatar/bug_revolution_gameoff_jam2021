extends Node2D

signal cooldown_end()

export var gol_scena_key:String = 'laser_gun'
export var speed:float = 100
export var power:float = 1
export var distance:float =2000
export var shoot_in_second:float =1

export var input_from_user:bool = false

var Bullet = preload("res://src/weapons/laser_gun/laser_shoot.tscn")
var map_bullet:=Dictionary()
var isColddown:bool = false
var isSend:bool = false
var timer_cooldown:Timer
var gol:GlobalObjectLogic
var shoot_count:int =0

# Called when the node enters the scene tree for the first time.
func _ready():
	gol = GlobalObjectLogic.new()
	gol.gol_type = 'item'
	gol.gol_scena_key = gol_scena_key
	gol.event_handlers = {'shoot':funcref(self, '_event_handler_shoot')}
	timer_cooldown = Timer.new()
	timer_cooldown.autostart = false
	timer_cooldown.wait_time = 1/shoot_in_second
	timer_cooldown.connect("timeout", self, "_timeout")
	catch_input_from_user(input_from_user)
	add_child(timer_cooldown)
	add_child(gol)
	

#func _input(event):
#	if Input.is_action_pressed("fire"):
#		shoot()
		
func _process(delta):
	if Input.is_action_pressed("fire"):
		shoot()
		
func catch_input_from_user(on:bool):
	input_from_user = on
	#set_process_input(input_from_user)
	set_process(on)

func shoot():
	if !isSend and !isColddown:
		isSend = true
		#print('need_shoot to',get_global_mouse_position())
		var v = Vector2(0,-1).rotated(global_transform.get_rotation())
		var tmp = gol.createAction('shoot',{'direction_x':v.x,'direction_y':v.y})
		gol.gol_send_action(tmp)
		
		
func _timeout():
	isColddown = false
	timer_cooldown.stop()
	emit_signal("cooldown_end")

func _event_handler_shoot(data:Dictionary):
	isSend = false
	var dir
	if data.has('direction_x') and data.has('direction_y') :
		dir = Vector2(data['direction_x'],data['direction_y'])
		if !isColddown:
			var bull = Bullet.instance()
			bull.id = shoot_count
			bull.speed = speed
			bull.distance = distance
			bull.power = power
			bull.init_shoot_direction(global_position+Vector2(0,-66).rotated(global_transform.get_rotation()),Vector2(data['direction_x'],data['direction_y']),bull.id)
			bull.connect('move_end',self,'_move_end')
			bull.connect('target_hit',self,'_target_hit')
			map_bullet[shoot_count]=bull
			shoot_count+=1
			find_parent('body_scena').add_child(bull)
			isColddown = true
			$AudioStreamPlayer2D.play()
			timer_cooldown.start(1/shoot_in_second)
	else:
		printerr('ERROR GOL EVENT shoot in laser_gun data:',data)

func _move_end(id):
	if map_bullet.has(id):
		if map_bullet[id].is_inside_tree():
			#get_tree().root.remove_child(net)
			_remove_bullet_from_map(id)

func _remove_bullet_from_map(id):
	if map_bullet.has(id):
		map_bullet[id].queue_free()
		map_bullet.erase(id)

func _target_hit(body,id):
	if body.has_method('collisionEvent'):
		body.collisionEvent('dmg',power)
	_remove_bullet_from_map(id)
	


func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.stop()
