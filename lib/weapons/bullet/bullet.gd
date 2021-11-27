extends Node2D

signal move_end(id)
signal target_hit(body,id)

export var speed:float = 1000
export var distance:float =2000
export var power:float =1

var to_target:Vector2
var _kostil_start_process:bool = true
var rotation_dir:float #normalized
var distance_last:float=0
var scale_speed:Vector2
var id:int =0
func init_shoot_target(from:Vector2, to:Vector2 ,id:int):
	self.id = id
	position = from
	to_target = from.direction_to(to)
	rotation = to_target.dot(Vector2(0,1).rotated(global_transform.get_rotation()-1.57))
	#print('Bullet Shoot:',from,' -> ',to,' calc:',to_target)

func init_shoot_direction(from:Vector2,dir:Vector2,id:int):
	position = from
	to_target = dir
	#rotation_dir = to_target.dot(Vector2(0,-1))
	rotation = 6.28-to_target.angle_to(Vector2(0,-1))
	self.id = id


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("tree_exiting",self,'_tree_exiting')
	set_physics_process(true)
	
func _tree_exiting():
	print(name,' id:',id,' tree_exiting')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	position = position + Vector2(to_target.x*speed*delta/(1),to_target.y*speed*delta/(1))
	distance_last +=speed*delta
	if distance_last>=  distance:
		print(name,' shoot move_end in ',position,' dist:',distance_last)
		set_physics_process(false)
		emit_signal("move_end",id)
		_kostil_start_process=false


func _on_Area2D_body_entered(body):
	print(name,' shoot ',id,' target hit in ',position,' dist:',distance_last)
	set_physics_process(false)
	#if body.has_method('collisionEvent'):
	#	body.collisionEvent('stun',power)
	emit_signal("target_hit",body,id)
	
