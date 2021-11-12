extends Node2D

export var speed:float = 10
export var begin_scale:Vector2 = Vector2(0.2,0.2)
export var end_scale:Vector2 = Vector2(1,1)
export var speed_rotate:float = 10
export var distance:float =50

var Net = preload("res://src/weapons/staner/net.tscn")
var net
var isColddown:bool = false
var timer_test

# Called when the node enters the scene tree for the first time.
func _ready():
	#timer_test = Timer.new()
	#timer_test.autostart = true
	#timer_test.wait_time = 5
	#timer_test.connect("timeout", self, "_timeout")
	#add_child(timer_test)
	pass

func shoot():
	if !isColddown:
		net = Net.instance()
		net.speed = speed
		net.begin_scale = begin_scale
		net.end_scale = end_scale
		net.speed_rotate = speed_rotate
		net.distance = distance
		net.init(global_position,get_global_mouse_position())
		net.connect('move_end',self,'_move_end')
		net.connect('target_hit',self,'_target_hit')
		get_tree().root.add_child(net)
		isColddown = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _move_end():
	
	if net!=null:
		if net.is_inside_tree():
			#get_tree().root.remove_child(net)
			isColddown = false
			net.queue_free()
	
func _target_hit(area):
	#var arr = area.get_overlapping_bodies() as Array
	if area.overlaps_body(GlobalResource.game_data['ai_actor_node'] ):
		print('I HIT BUG')
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

func _timeout():
	shoot()
