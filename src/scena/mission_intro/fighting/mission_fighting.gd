extends Control

export var gol_scena_key:String = 'mission_fighting'
export var isDebug =false
export var num_solders:int = 2
var BUG = preload("res://src/character/bug/gol_bug_fighter.tscn")
var SCIENCE = preload("res://src/character/science/gol_science_fighter.tscn")
var ui_science = preload("res://src/ui/science_ui.tscn")
var BEAR = preload("res://src/character/bears/gol_bear.tscn")
var SOLDER = preload("res://src/character/solder/solder.tscn")
var CHEBUREK = preload("res://src/map_items/cheburek/cheburek.tscn")
var ai

var solders:Array
var _solder_count:int =0
var _solder_mask:int =0

var _scientist
var _bug
var chebureks:Array
var _cheburek_count:int =0


var gol:GlobalObjectLogic 

# Called when the node enters the scene tree for the first time.
func _ready():
	if !isDebug:
		GlobalResource.game_data['game_state'] = 6
		GlobalResource.game_data['game_fighting_status'] = 0
		GolMaster.permission = true
		GlobalResource.game_data['pop_warning']  = $warning
		GlobalResource.game_data['game_event'] = $GameEvent
		gol = GlobalObjectLogic.new()
		gol.gol_scena_key = gol_scena_key
		gol.gol_type = 'scena'
		gol.event_handlers = {
			'add':funcref(self, '_event_handler_add'),
			'remove':funcref(self, '_event_handler_remove'),
			'change_scena':funcref(self, '_event_change_scena')}
		add_child(gol)
		
		_bug = BUG.instance()
		_scientist = SCIENCE.instance()
		_scientist.current_item = 1
		for i in range(0,num_solders):
			var s = SOLDER.instance()
			s.set_AI(true)
			if GlobalResource.game_data['isServer']:
				s.inServer = true
			s.get_node("Actor").position = Vector2(1500,4500-i*100)
			s.id=_solder_count
			s.gol_scena_key = 'solder_%d'%_solder_count
			solders.push_back(s)
			_solder_mask |=(1<<i+3)
			_solder_count+=1
			
			$ViewportContainer/Viewport/body_scena.add_child(s)
		if GlobalResource.game_data['player_type'] == 'bug':
			_bug.set_AI(false)
			_scientist.set_AI(true)
			GlobalResource.game_data['player'] = _bug
			ai = _scientist
			#GlobalResource.game_data['science'] = ai.get_node("Actor")
			#GlobalResource.game_data['bug'] = BUG.get_node("Actor")
		elif GlobalResource.game_data['player_type'] == 'science':
			#BUG.isClientOn = false
			#SCIENCE.isClientOn = true
			ai = _bug
			_bug.set_AI(true)
			_scientist.set_AI(false)
			GlobalResource.game_data['player'] = _scientist
			#SCIENCE.add_child(ui_science)
			#GlobalResource.game_data['ai_actor_node'] = ai.get_node("Actor")
			#GlobalResource.game_data['player_actor_node'] = SCIENCE.get_node("Actor")
		_bug.get_node("Actor").set_position(Vector2(4350,2150))
		_scientist.get_node("Actor").set_position(Vector2(4350,2300))
		#$CanvasModulate.add_child(BUG)
		#$CanvasModulate.add_child(SCIENCE)
		$ViewportContainer/Viewport/body_scena.add_child(_bug)
		$ViewportContainer/Viewport/body_scena.add_child(_scientist)
		#$ViewportContainer/Viewport/body_scena.add_child(bear)
		
		$Control.init()
		
func _event_change_scena(data:Dictionary):
	GolMaster.permission = false
	if data.has('new_scena'):
		if data.has('info'):
			if data['info']=='allDead':
				GlobalResource.game_data['game_state'] = 10
			if data['info']=='solderDead':
				if GlobalResource.game_data['game_fighting_status'] & 3 == 1:  
					GlobalResource.game_data['game_state'] = 8
				elif GlobalResource.game_data['game_fighting_status'] & 3 == 2:
					GlobalResource.game_data['game_state'] = 9
				elif GlobalResource.game_data['game_fighting_status'] & 3 == 0:
					GlobalResource.game_data['game_state'] = 7
		get_tree().change_scene(data['new_scena']) 
	
func _event_handler_add(data:Dictionary):
	if data.has('type') and data.has('positionX') and data.has('positionY'):
		if data['type']=='cheburec':
			var c = CHEBUREK.instance()
			c.position = Vector2(data['positionX'],data['positionY'])
			c.id = _cheburek_count
			_cheburek_count +=1
			chebureks.push_back(c)
			$ViewportContainer/Viewport/body_scena.add_child(c)
			
func _event_handler_remove(data:Dictionary):
	if data.has('type') and data.has('id'):
		if data['type']=='cheburec':
			var tmp
			for i in range(0, chebureks.size()):
				if chebureks[i].id == data['id']:
					tmp=i
					$ViewportContainer/Viewport/body_scena.remove_child(chebureks[i])
					break
			if tmp != null:
				var c = chebureks[tmp]
				chebureks.remove(tmp)
				c.call_deferred('free')

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		$game_menu.popup_centered(Vector2(170,170))


func _process(delta):
	if GlobalResource.game_data['game_fighting_status'] & 3 == 3: 
		GlobalResource.game_data['game_event'].send_event('All Dead!!!',false,"res://src/scena/mission_intro/end/end.tscn",'allDead')
	if GlobalResource.game_data['game_fighting_status'] & _solder_mask == _solder_mask: 
		GlobalResource.game_data['game_event'].send_event('Solder is dead',false,"res://src/scena/mission_intro/end/end.tscn",'solderDead')
		
#func _new_data_about_ai(json):
#	ai.set_position(Vector2(json['pos_x'],json['pos_y']))
#	ai.set_rotate(json['rotation'])
#	ai.set_stamina(json['stamina'])
#	ai.set_state(json['state'])
