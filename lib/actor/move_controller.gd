extends Node2D


enum eActorMoveMode{
	EIGHT_WAY_MOVEMENT,
	ROTATION_AND_MOVEMENT,
	MOUSE_ROTATION_AND_MOVEMENT
}
export var mode:int = eActorMoveMode.MOUSE_ROTATION_AND_MOVEMENT

var velocity:Vector2
var rotate_angle:float

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	

func getInputVelocityAndRotation(pos,rot)->Array:
	if mode == eActorMoveMode.EIGHT_WAY_MOVEMENT:
		return _get_input_EIGHT_WAY_MOVEMENT()
	if mode == eActorMoveMode.ROTATION_AND_MOVEMENT:
		return _get_input_ROTATION_AND_MOVEMENT()
	if mode == eActorMoveMode.MOUSE_ROTATION_AND_MOVEMENT:
		return _get_input_MOUSE_ROTATION_AND_MOVEMENT(pos,rot)
	return []
	
func _get_input_EIGHT_WAY_MOVEMENT()->Array:
	velocity = Vector2()
	rotate_angle = 0
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	if velocity.x !=0 or velocity.y !=0: # тоесть мы двигаемся
		velocity = velocity.normalized()
	return [velocity.x,velocity.y,rotate_angle]

func _get_input_ROTATION_AND_MOVEMENT()->Array:
	velocity = Vector2()
	rotate_angle = 0
	if Input.is_action_pressed("ui_right"):
		rotate_angle += 1
	if Input.is_action_pressed("ui_left"):
		rotate_angle -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	if velocity.x !=0 or velocity.y !=0 or rotate_angle!=0: # тоесть мы двигаемся
		velocity = velocity.normalized()
	return [velocity.x,velocity.y,rotate_angle]
	
func _get_input_MOUSE_ROTATION_AND_MOVEMENT(pos,rot)->Array:
	velocity = Vector2()
	rotate_angle = 0
	
	var need_rotate_to = pos.direction_to(get_global_mouse_position()) #направление мышки определяет куда нам надо повернутся
	rotate_angle = need_rotate_to.dot(Vector2(0,1).rotated(rot-1.57))#rad 1.57 = 90gradus поворачиваем нормальный вектор на наш rotation и находи угол который нам надо 
	#print('Actor:cur_rotate:',rotation,' need_rotate_to:',need_rotate_to,' rotation_dir:',rotate_angle)
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.x !=0 or velocity.y !=0 or rotate_angle!=0: # тоесть мы двигаемся
		velocity = velocity.normalized()
	return [velocity.x,velocity.y,rotate_angle]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
