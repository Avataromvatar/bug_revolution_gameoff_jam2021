extends Control

export var gol_scena_key:String = 'scena_intro'
export var isDebug =false
var BUG = preload("res://src/character/bug/gol_bug.tscn").instance()
var SCIENCE = preload("res://src/character/science/gol_science.tscn").instance()
var ui_science = preload("res://src/ui/science_ui.tscn").instance()
var BEAR = preload("res://src/character/bears/gol_bear.tscn")
var SOLDER = preload("res://src/character/solder/solder.tscn")
var CHEBUREK = preload("res://src/map_items/cheburek/cheburek.tscn")
var ai

var solders:Array
var _solder_count:int =0

var chebureks:Array
var _cheburek_count:int =0

var gol:GlobalObjectLogic 

# Called when the node enters the scene tree for the first time.
func _ready():
	if !isDebug:
		GolMaster.permission = true
		GlobalResource.game_data['pop_warning']  = $warning
		gol = GlobalObjectLogic.new()
		gol.gol_scena_key = gol_scena_key
		gol.gol_type = 'scena'
		gol.event_handlers = {
			'add':funcref(self, '_event_handler_add'),
			'remove':funcref(self, '_event_handler_remove'),
			'change_scena':funcref(self, '_event_change_scena')}
		if GlobalResource.game_data['player_type'] == 'bug':
			#BUG.isClientOn = true
			#SCIENCE.isClientOn = false
			BUG.set_AI(false)
			SCIENCE.set_AI(true)
			GlobalResource.game_data['player'] = BUG
			ai = SCIENCE
			#GlobalResource.game_data['science'] = ai.get_node("Actor")
			#GlobalResource.game_data['bug'] = BUG.get_node("Actor")
		elif GlobalResource.game_data['player_type'] == 'science':
			#BUG.isClientOn = false
			#SCIENCE.isClientOn = true
			ai = BUG
			BUG.set_AI(true)
			SCIENCE.set_AI(false)
			GlobalResource.game_data['player'] = SCIENCE
			#SCIENCE.add_child(ui_science)
			#GlobalResource.game_data['ai_actor_node'] = ai.get_node("Actor")
			#GlobalResource.game_data['player_actor_node'] = SCIENCE.get_node("Actor")
		elif GlobalResource.game_data['player_type'] == 'solder':
			BUG.set_AI(true)
			SCIENCE.set_AI(true)
			var solder = SOLDER.instance()
			solder.get_node("Actor").set_position(Vector2(1500,4700))
			if GlobalResource.game_data['isServer']:
				solder.inServer = true
			solder.gol_scena_key = 'solder1'+str(_solder_count)
			_solder_count+=1
			solders.push_back(solder)
			solder.set_AI(false)
			$ViewportContainer/Viewport/body_scena.add_child(solder)
			GlobalResource.game_data['player'] = solder
		var bear = BEAR.instance()
		bear.get_node("Actor").set_position(Vector2(4500,800))
		if GlobalResource.game_data['isServer']:
			bear.inServer = true
		#GlobalResource.game_data['science'] = SCIENCE.get_node("Actor")
		#GlobalResource.game_data['bug'] = BUG.get_node("Actor")
		BUG.get_node("Actor").set_position(Vector2(4000,800))
		SCIENCE.get_node("Actor").set_position(Vector2(3750,2500))
		#$CanvasModulate.add_child(BUG)
		#$CanvasModulate.add_child(SCIENCE)
		$ViewportContainer/Viewport/body_scena.add_child(BUG)
		$ViewportContainer/Viewport/body_scena.add_child(SCIENCE)
		#$ViewportContainer/Viewport/body_scena.add_child(bear)
		add_child(gol)
		$Control.init()
		
func _event_change_scena(data:Dictionary):
	GolMaster.permission = false
	if data.has('new_scena'):
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
	
#func _new_data_about_ai(json):
#	ai.set_position(Vector2(json['pos_x'],json['pos_y']))
#	ai.set_rotate(json['rotation'])
#	ai.set_stamina(json['stamina'])
#	ai.set_state(json['state'])
