extends Node2D

signal move_end(id)
signal target_hit(body,id)

export var speed:float = 100
export var distance:float =2000
export var power:float =1

var id
var body
var _isTargetHit:bool = false
var _animation_on:bool = false
func _init_basic():
	$acid.speed = speed
	$acid.distance = distance
	$acid.power = power

func init_shoot_target(from:Vector2, to:Vector2 ,id:int):
	self.id = id
	#position = from
	_init_basic()
	$acid.init_shoot_target(from,to,id)
	

func init_shoot_direction(from:Vector2,dir:Vector2,id:int):
	self.id = id
	#position = from
	_init_basic()
	$acid.init_shoot_direction(from,dir,id)

# Called when the node enters the scene tree for the first time.
func _ready():
	$acid.connect("move_end",self,'_move_end')
	$acid.connect("target_hit",self,'_target_hit')

func _move_end(id):
	emit_signal("move_end",self.id)

func _target_hit(body,id):
	_isTargetHit = true
	self.body = body 
	self.id=id
	$acid/AnimatedSprite.show()
	_animation_on = true
	$acid/AnimatedSprite.play('explosiv')
	$acid/Sprite.hide()
	

func _on_AnimatedSprite_animation_finished():
	if _animation_on:
		_animation_on =false
		if _isTargetHit:
			emit_signal("target_hit",body,id)
		else:
			emit_signal("move_end",self.id)
		$acid/AnimatedSprite.hide()
