extends Node

export var gol_scena_key:String = 'bug' setget gol_scena_key_change
export var isAI:bool=false
export var hit:float = 10

var score:int = 0
var score_need:int = 20
var cheburek_eats:Dictionary ={}

var inServer:bool = false
var gol:GlobalObjectLogic
var time_count:float = 0

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

func set_AI(on:bool):
	isAI=on
	$Actor.set_AI(on)
	$Actor.set_camera(!on)
	$Actor.set_light(!on)
	$Actor/Bug_acid.catch_input_from_user(!on)
	
func _collision_event(type:String,data):
	if type == 'stun':
		hit -=data
		if hit<=0:
			print(name,' Cathed!!!')
		else:
			print(name,' DMG: ',data,' HIT:',hit)
	if type == 'dmg':
		hit -=data
		if hit<=0:
			print(name,' DIE!')
		else:
			print(name,' DMG: ',data,' HIT:',hit)
	if hit<=0:
		var gscena = find_parent('SCENA')
		var a =  gol.createActionTo('scena',gscena.gol_scena_key,'change_scena',{'new_scena':"res://main.tscn"})
		gol.gol_send_action(a)
	if type == 'cheburec':
		if !cheburek_eats.has(data):
			cheburek_eats[data]=true
			score+=1
			var gscena = find_parent('SCENA')
			var act = gol.createActionTo('scena',gscena.gol_scena_key,'remove',{'type':'cheburec','id':data})
			gol.gol_send_action(act)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
