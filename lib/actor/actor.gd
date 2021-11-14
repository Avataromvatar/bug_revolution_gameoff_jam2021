extends KinematicBody2D
class_name ActorKinematicBody2D

enum eActorMoveMode{
	EIGHT_WAY_MOVEMENT,
	ROTATION_AND_MOVEMENT,
	MOUSE_ROTATION_AND_MOVEMENT
}
enum eActorState{
	IDLE,
	MOVE,
	RUN,
	STAMINA_RECOVERY
}


signal stamina_change(stamina)
signal actor_state_change(state)
signal position_change(position,rotate)
signal collision_event(type,data)

export var isAI:bool = false
export var speed_rotate:float = 5.0
export var speed_move_forward:float = 100.0
export var speed_move_streve:float = 50.0
export var speed_move_back:float = 50.0
export var mode:int = eActorMoveMode.MOUSE_ROTATION_AND_MOVEMENT
##if =0 then run speed = run_speed
export var run_acceleration:float = 0 
export var run_speed:float = 250 ##just forward 
export var run_start_speed:float = 100 ##just forward 
export var staminaOn:bool = false
export var stamina_max:float = 50 ##just forward 
export var stamina_min:float = 15 ##then STAMINA_RECOVERY state
export var stamina_regen_when_move:float = 2 ##just forward 
export var stamina_regen_when_idle:float = 5
export var stamina_use_then_run:float = 10 ##just forward 

var stamina:float = 0
var stamina_last:float = 0

var velocity:Vector2 = Vector2(0,0)
var forward_speed:float = 0
var rotation_dir:float = 0

var state:int = eActorState.IDLE

func collisionEvent(type:String, data):
	emit_signal("collision_event",type,data)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	stamina = stamina_max
	if staminaOn:
		emit_signal("stamina_change",stamina)
	emit_signal("actor_state_change",state)
	if isAI:
		set_physics_process(false)
	
func _get_input():
	pass

func _change_state(new_state:int):
	if state != new_state:
		#print('Change state ',state,' to ',new_state)
		state = new_state
		if state == eActorState.RUN:
			forward_speed = run_start_speed
		if state == eActorState.MOVE:
			forward_speed = speed_move_forward
		if state == eActorState.IDLE or state ==eActorState.STAMINA_RECOVERY:
			forward_speed = 0
		emit_signal("actor_state_change",state)

func set_stamina(new_stamina:float):
	if new_stamina >stamina_max:
		new_stamina = stamina_max
	if new_stamina <0:
		new_stamina = 0
	if new_stamina != stamina_last:
		#print('Change stamina ',stamina,' to ',new_stamina)
		emit_signal("stamina_change",stamina)
		stamina = new_stamina
		stamina_last = stamina
		if stamina == 0 and state != eActorState.IDLE and state != eActorState.STAMINA_RECOVERY:
			_change_state(eActorState.STAMINA_RECOVERY)
	

##производит перемещение с учетом состояния ускорения и стамины
func need_movement(normalized_velocity:Vector2,delta)->Vector2:
	if normalized_velocity.x ==0 and normalized_velocity.y ==0 and rotation_dir==0:
		if staminaOn:
			set_stamina(stamina+stamina_regen_when_idle*delta)
			if state == eActorState.STAMINA_RECOVERY:
				if stamina >=stamina_min:
					_change_state(eActorState.IDLE)
		if state == eActorState.MOVE or state == eActorState.RUN:
			_change_state(eActorState.IDLE)
	if state == eActorState.STAMINA_RECOVERY:
		if staminaOn:
			set_stamina(stamina+stamina_regen_when_idle*delta)
	if state == eActorState.MOVE:
		if staminaOn:
			set_stamina(stamina+stamina_regen_when_move*delta)
		if normalized_velocity.x!=0: #streve 
			normalized_velocity.x = velocity.x*speed_move_streve
		if normalized_velocity.y > 0: #move back
			normalized_velocity.y = normalized_velocity.y*speed_move_back 
		if normalized_velocity.y < 0: #move forward
			normalized_velocity.y = normalized_velocity.y*forward_speed
	if state == eActorState.RUN:
		if staminaOn:
			set_stamina(stamina-stamina_use_then_run*delta)
		if run_acceleration != 0:
			forward_speed +=run_acceleration*delta
			if forward_speed>run_speed:
				forward_speed = run_speed
		else:
			forward_speed = run_speed
		if normalized_velocity.x!=0: #streve 
			normalized_velocity.x = velocity.x*speed_move_streve
		if normalized_velocity.y > 0: #move back
			normalized_velocity.y = normalized_velocity.y*speed_move_back 
		if normalized_velocity.y < 0: #move forward
			normalized_velocity.y = normalized_velocity.y*forward_speed
	return normalized_velocity
	
func need_rotate():
	pass
	
func _get_input_EIGHT_WAY_MOVEMENT(delta):
	velocity = Vector2()
	rotation_dir = 0
	if state!=eActorState.STAMINA_RECOVERY: #если мы не восстанавливаемся после бега
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if velocity.x !=0 or velocity.y !=0: # тоесть мы двигаемся
			if Input.is_action_pressed("ui_run"): 
				_change_state(eActorState.RUN)
			else:
				if state == eActorState.IDLE or state == eActorState.RUN:
					_change_state(eActorState.MOVE)
			velocity = velocity.normalized()
		else:
			_change_state(eActorState.IDLE)
	velocity=need_movement(velocity,delta)
		

func _get_input_ROTATION_AND_MOVEMENT(delta):
	velocity = Vector2()
	rotation_dir = 0
	if state!=eActorState.STAMINA_RECOVERY: #если мы не восстанавливаемся после бега
		if Input.is_action_pressed("ui_right"):
			rotation_dir += 1
		if Input.is_action_pressed("ui_left"):
			rotation_dir -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if velocity.x !=0 or velocity.y !=0 or rotation_dir!=0: # тоесть мы двигаемся
			if Input.is_action_pressed("ui_run"): 
				_change_state(eActorState.RUN)
			else:
				if state == eActorState.IDLE or state == eActorState.RUN:
					_change_state(eActorState.MOVE)
			velocity = velocity.normalized()
		else:
			_change_state(eActorState.IDLE)
	velocity=need_movement(velocity,delta)
	
	
func _get_input_MOUSE_ROTATION_AND_MOVEMENT(delta):
	velocity = Vector2()
	rotation_dir = 0
	if state!=eActorState.STAMINA_RECOVERY: #если мы не восстанавливаемся после бега
		var need_rotate_to = position.direction_to(get_global_mouse_position()) #направление мышки определяет куда нам надо повернутся
		rotation_dir = need_rotate_to.dot(Vector2(0,1).rotated(rotation-1.57))#rad 1.57 = 90gradus поворачиваем нормальный вектор на наш rotation и находи угол который нам надо 
		#print('Actor:cur_rotate:',rotation,' need_rotate_to:',need_rotate_to,' rotation_dir:',rotation_dir)
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if velocity.x !=0 or velocity.y !=0 or rotation_dir!=0: # тоесть мы двигаемся
			if Input.is_action_pressed("ui_run"): 
				_change_state(eActorState.RUN)
			else:
				if state == eActorState.IDLE or state == eActorState.RUN:
					_change_state(eActorState.MOVE)
			velocity = velocity.normalized()
		else:
			_change_state(eActorState.IDLE)
	velocity=need_movement(velocity,delta)
	
	
	
func _physics_process(delta):
	if isAI:
		set_physics_process(false)
	if !isAI:
		if mode == eActorMoveMode.EIGHT_WAY_MOVEMENT:
			_get_input_EIGHT_WAY_MOVEMENT(delta)
		else:
			if mode == eActorMoveMode.ROTATION_AND_MOVEMENT:
				_get_input_ROTATION_AND_MOVEMENT(delta)
			else:
				if mode == eActorMoveMode.MOUSE_ROTATION_AND_MOVEMENT:
					_get_input_MOUSE_ROTATION_AND_MOVEMENT(delta)
				
	rotation += rotation_dir * speed_rotate * delta
	velocity = move_and_slide(velocity.rotated(rotation))
	if state != eActorState.IDLE and state != eActorState.STAMINA_RECOVERY:
		emit_signal("position_change",position,rotation)
	#print('position change:',position,' rotate:',rotation)
