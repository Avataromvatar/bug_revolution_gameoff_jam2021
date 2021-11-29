extends Node

export var gol_scena_key:String = 'bug' setget gol_scena_key_change
export var isAI:bool=false
export var hit:float = 10
export var max_hit:float = 25
export var cheburek_heal:float = 3
export var mutation_dmg:float = 0
export var regen_on:bool = true
export var regen_speed:float = 0.02
var sec_count:float = 0

var score:int = 0
var score_need:int = 40
var cheburek_eats:Dictionary ={}

var inServer:bool = false
var gol:GlobalObjectLogic
var time_count:float = 0
var isDead:bool = false
func gol_scena_key_change(scena_key:String):
	gol_scena_key = scena_key
	$Actor.gol_scena_key = gol_scena_key+'_actor'
	$Actor/Bug_acid.gol_scena_key = gol_scena_key+'_bug_acid'
	if gol != null:
		gol.gol_scena_key = scena_key

# Called when the node enters the scene tree for the first time.
func _ready():
		
	if GlobalResource.game_data['isServer']:
		inServer = true
	gol = GlobalObjectLogic.new()
	gol.gol_scena_key = gol_scena_key
	gol.gol_type = 'character'	
	$Actor.gol_scena_key = gol_scena_key+'_actor'
	set_AI(isAI)
	$Actor.connect("collision_event",self,'_collision_event')
	GlobalResource.game_data['bug_actor'] = $Actor
	GlobalResource.game_data['bug'] = self

func set_isDead():
	if !isDead:
		isDead = true
		$Actor/isDead.show()
		$Actor/AnimatedSprite.hide()
		set_process(false)
		set_physics_process(false)
		$Actor.set_physics_process(false)
		$Actor/CollisionShape2D.disabled = true
		GlobalResource.game_data['game_fighting_status'] |=2 
	
func set_AI(on:bool):
	isAI=on
	$Actor.set_AI(on)
	$Actor.set_camera(!on)
	$Actor.set_light(!on)
	if GlobalResource.game_data['game_state'] != 3:  
		$Actor/Bug_acid.catch_input_from_user(!on)
	else:
		$Actor/Bug_acid.catch_input_from_user(false)
	
func _collision_event(type:String,data):
	if type == 'stun':
		hit -=data
		if hit<=0:
			#GlobalResource.game_data['game_event'].send_event('The bug is caught!!!',false,"res://src/scena/mission_intro/end/end.tscn",'bugDIE')
			print(name,' Cathed!!!')
		else:
			print(name,' DMG: ',data,' HIT:',hit)
	if type == 'dmg':
		hit -=data
		if hit<=0:
			#GlobalResource.game_data['game_event'].send_event('The bug is DIE!!!',false,"res://src/scena/mission_intro/end/end.tscn",'bugDIE')
			print(name,' DIE!')
			set_isDead()
		else:
			print(name,' DMG: ',data,' HIT:',hit)
	#if hit<=0:
	#	var gscena = find_parent('SCENA')
	#	var a =  gol.createActionTo('scena',gscena.gol_scena_key,'change_scena',{'new_scena':"res://main.tscn"})
	#	gol.gol_send_action(a)
	if type == 'cheburec':
		if !cheburek_eats.has(data):
			cheburek_eats[data]=true
			score+=1
			hit +=cheburek_heal
			var gscena = find_parent('SCENA')
			var act = gol.createActionTo('scena',gscena.gol_scena_key,'remove',{'type':'cheburec','id':data})
			gol.gol_send_action(act)
			if score>score_need:
				GlobalResource.game_data['game_event'].send_event('The bug mutation end',false,"res://src/scena/mission_intro/state4/state4.tscn",'bugWIN')
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sec_count +=delta
	if sec_count>=1:
		sec_count=0
		hit -=mutation_dmg
		if regen_on:
			hit+=regen_speed
		if hit>max_hit:
			hit = max_hit
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
