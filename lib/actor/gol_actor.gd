extends KinematicBody2D

var moveController = preload("res://lib/actor/move_controller.gd").new()

signal actor_state_change(state)
signal collision_event(type,data)
#signal ai_need_move(pos,rot)

enum eActorState{
	IDLE,
	MOVE,
	RUN,
	STAMINA_RECOVERY
}
var gol:GlobalObjectLogic
export var gol_scena_key:String setget gol_scena_key_change
export var mode:int = 0
export var isAI:bool = false
export var speed_rotate:float = 5.0
#export var rrotate:float = 1.57
export var speed_move_forward:float = 100.0
export var speed_move_streve:float = 50.0
export var speed_move_back:float = 50.0
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

var forward_speed:float = 0
var arrToUpdateFromServer:Array = [0,0,0]
var isChange:bool = false #if position or rotate or state change
var changeAccept:bool = false #if server accept changes
var action:GlobalObjectLogicDTO
var state:int = eActorState.IDLE
var gol_data:Dictionary={'x':0,'y':0,'angle':0,'stamina':0,'state':eActorState.IDLE}
var isRotate:bool = false
var isWalk:bool = false
var isPathMove:=false
var path :=PoolVector2Array()


func gol_scena_key_change(scena_key:String):
	gol_scena_key = scena_key
	if gol != null:
		gol.gol_scena_key = scena_key
	
# Called when the node enters the scene tree for the first time.
func _ready():
	#for test
	#GolServer.listen()
	#GolMaster.connect_to_server()
	
	gol = GlobalObjectLogic.new()
	gol.gol_scena_key = gol_scena_key
	gol.gol_type = 'actor'
	action = gol.createAction('move',gol_data)
	gol.event_handlers = {'move':funcref(self, '_event_handler_update')}
	stamina = stamina_max
	moveController.mode = mode
	add_child(gol)
	add_child(moveController)
	#$Camera2D.current = true
	if isAI:
		set_physics_process(false)
		#$Camera2D.current = false
		
func collisionEvent(type:String, data):
	emit_signal("collision_event",type,data)
	
func set_camera(on:bool):
	var c = find_node('Camera2D')
	if c != null:
		c.set_deferred('current',on)

func set_light(on:bool):
	var l = find_node('Light2D')
	if l!=null:
		l.set_deferred('enabled',on)
	
func set_AI(on:bool):
	isAI = on
	set_physics_process(!on)
	#set_camera(!on)
	#set_light(!on)

func move_by_path(new_path:PoolVector2Array):
	if isAI:
		isPathMove = true
		path = new_path
		set_physics_process(true)
		
#update path from ai. need return arr [x,y,rotate,isRun 1 or 0]
#this is only direction
func _update_path(delta)->Array:
	if path.size()>0:
		var need_rotate_to = global_position.direction_to(path[0]) #направление мышки определяет куда нам надо повернутся
		var rotate_angle = need_rotate_to.dot(Vector2(0,1).rotated(rotation-1.57))#
		return [0,-1,rotate_angle,0]
	else:
		print(gol_scena_key,' STOP PATH')
		set_physics_process(false)
		return [0,0,0,0]
	
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
		isChange = true
		emit_signal("actor_state_change",state)

func set_stamina(new_stamina:float):
	if new_stamina >stamina_max:
		new_stamina = stamina_max
	if new_stamina <0:
		new_stamina = 0
	if new_stamina != stamina_last:
		#print('Change stamina ',stamina,' to ',new_stamina)
		#emit_signal("stamina_change",stamina)
		isChange = true
		stamina = new_stamina
		stamina_last = stamina
		if stamina == 0 and state != eActorState.IDLE and state != eActorState.STAMINA_RECOVERY:
			_change_state(eActorState.STAMINA_RECOVERY)
##производит перемещение с учетом состояния ускорения и стамины
func _update(delta):
	var arr:=Array() #[x,y,rotate,isRun 1 or 0]
	var isRun =false
	#Get main data(arr) from input or AI path
	if !isAI:
		arr = moveController.getInputVelocityAndRotation(position,rotation) #arr.lenght = 3
		if Input.is_action_pressed("ui_run") : 
			arr.push_back(1)
		else:
			arr.push_back(0)
	elif isPathMove:
		arr = _update_path(delta)
					
	var velocity = Vector2(arr[0],arr[1])
	var rotate_angle = arr[2]
	
	if arr[0]!=0 or arr[1]!=0 or arr[2]!=0:
		isChange =true
		if state !=eActorState.STAMINA_RECOVERY:
			if arr[3]==1: 
				_change_state(eActorState.RUN)
			else:
				if state == eActorState.IDLE or state == eActorState.RUN:
					_change_state(eActorState.MOVE)
	if arr[0]==0 and arr[1]==0:
		isWalk = false
	else:
		isWalk = true
	if arr[2] > 0:
		isRotate = true
	else:
		isRotate = false	
	if state==eActorState.IDLE or state == eActorState.STAMINA_RECOVERY:
		if staminaOn:
			set_stamina(stamina+stamina_regen_when_idle*delta)
			if state == eActorState.STAMINA_RECOVERY:
				if stamina >=stamina_min:
					_change_state(eActorState.IDLE)
	if velocity.x ==0 and velocity.y ==0 and rotate_angle==0:
		if state == eActorState.MOVE or state == eActorState.RUN:
			_change_state(eActorState.IDLE)
	
	if state == eActorState.MOVE:
		if staminaOn:
			set_stamina(stamina+stamina_regen_when_move*delta)
		
		velocity.x = velocity.x*speed_move_streve
		if velocity.y > 0: #move back
			velocity.y = velocity.y*speed_move_back 
		if velocity.y < 0: #move forward
			velocity.y = velocity.y*forward_speed
	if state == eActorState.RUN:
		if staminaOn:
			set_stamina(stamina-stamina_use_then_run*delta)
		if run_acceleration != 0:
			forward_speed +=run_acceleration*delta
			if forward_speed>run_speed:
				forward_speed = run_speed
		else:
			forward_speed = run_speed
		velocity.x = velocity.x*speed_move_streve
		if velocity.y > 0: #move back
			velocity.y = velocity.y*speed_move_back 
		if velocity.y < 0: #move forward
			velocity.y = velocity.y*forward_speed
	
	return [velocity.x,velocity.y,rotate_angle]
	
func _physics_process(delta):
	var arr 
	if !isAI:
		arr = _update(delta)
		#print(delta,' ',arr,' ',state)
		if isChange:
			rotation += arr[2] * speed_rotate * delta
			move_and_slide(Vector2(arr[0],arr[1]).rotated(rotation))
			isChange = false
			gol_data = {'x':position.x,'y':position.y,'angle':rotation,'stamina':stamina,'state':state}
			action.data = gol_data
			gol.gol_send_action(action)
	else:
		if isPathMove:
			# Calculate the movement distance for this frame
			#var distance_to_walk = speed_move_forward * delta
			arr = _update(delta)
			var velocity = Vector2(arr[0],arr[1])
			var distance_to_walk = velocity.length()
	# Move the player along the path until he has run out of movement or the path ends.
			if distance_to_walk > 0 and path.size() > 0:
				var distance_to_next_point = global_position.distance_to(path[0])
				rotation += arr[2] * speed_rotate * delta
				if distance_to_walk <= distance_to_next_point:
			# The player does not have enough movement left to get to the next point.
					move_and_slide(velocity.rotated(rotation))
					#position += position.direction_to(path[0]) * distance_to_walk
				else:
			# The player get to the next point
					move_and_slide(velocity.rotated(rotation))
					#position = path[0]
					path.remove(0)
				gol_data = {'x':position.x,'y':position.y,'angle':rotation,'stamina':stamina,'state':state}
				action.data = gol_data
				gol.gol_send_action(action)
			if path.size()==0:
				isPathMove = false
				set_physics_process(false)
		
func _event_handler_update(data:Dictionary):
	#if isAI:
	#	$Camera2D.current = false
	if data.has_all(['x','y','angle','stamina','state']):
		arrToUpdateFromServer = [data['x'],data['y'],data['angle']]
		state = data['state']
		stamina = data['stamina']
		rotation = arrToUpdateFromServer[2]
		position = Vector2(arrToUpdateFromServer[0],arrToUpdateFromServer[1])
	else:
		printerr('ERROR GOL EVENT update in gol_actor data:',data)
