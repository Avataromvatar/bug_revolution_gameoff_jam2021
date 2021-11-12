extends Node2D

signal move_end()
signal target_hit(area)

export var speed:float = 10
export var begin_scale:Vector2 = Vector2(0.2,0.2)
export var end_scale:Vector2 = Vector2(1,1)
export var speed_rotate:float = 10
export var distance:float =10
var to_target:Vector2

var rotation_dir:float #normalized
var distance_last:float=0
var scale_speed:Vector2

func init(from:Vector2, to:Vector2 ):
	
	position = from
	scale = begin_scale
	to_target = from.direction_to(to)
	scale_speed = Vector2((end_scale.x-begin_scale.x)/distance,(end_scale.y-begin_scale.y)/distance)
	print('Net Shoot:',from,' -> ',to,' calc:',to_target)
# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	position = position + Vector2(to_target.x*speed*delta/(1),to_target.y*speed*delta/(1))
	distance_last +=speed*delta
	scale = Vector2(scale_speed.x*distance_last,scale_speed.y*distance_last)
	$Area2D/CollisionPolygon2D.scale = scale
	$Area2D.scale = scale
	if distance_last>=  distance:
		print('Net shoot move_end in ',position,' dist:',distance_last)
		set_physics_process(false)
		emit_signal("move_end")
		
func _on_Area2D_area_entered(area):
	print('Net shoot target hit in ',position,' dist:',distance_last)
	set_physics_process(false)
	emit_signal("target_hit",area)
	#emit_signal("move_end")
	
