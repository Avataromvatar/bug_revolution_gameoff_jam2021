extends Control

export var gol_scena_key:String = 'scena_intro'
export var isDebug =false
var BUG = preload("res://src/character/bug/gol_bug.tscn").instance()
var SCIENCE = preload("res://src/character/science/gol_science.tscn").instance()
var ui_science = preload("res://src/ui/science_ui.tscn").instance()
var BEAR = preload("res://src/character/bears/gol_bear.tscn")
var ai


var gol:GlobalObjectLogic 

# Called when the node enters the scene tree for the first time.
func _ready():
	if !isDebug:
		gol = GlobalObjectLogic.new()
		gol.gol_scena_key = gol_scena_key
		gol.gol_type = 'scena'
		gol.event_handlers = {'add':funcref(self, '_event_handler_add'),'remove':funcref(self, '_event_handler_remove')}
		if GlobalResource.game_data['player_type'] == 'bug':
			#BUG.isClientOn = true
			#SCIENCE.isClientOn = false
			BUG.set_AI(false)
			SCIENCE.set_AI(true)
			
			ai = SCIENCE
			#GlobalResource.game_data['science'] = ai.get_node("Actor")
			#GlobalResource.game_data['bug'] = BUG.get_node("Actor")
		else:
			#BUG.isClientOn = false
			#SCIENCE.isClientOn = true
			ai = BUG
			BUG.set_AI(true)
			SCIENCE.set_AI(false)
			#SCIENCE.add_child(ui_science)
			#GlobalResource.game_data['ai_actor_node'] = ai.get_node("Actor")
			#GlobalResource.game_data['player_actor_node'] = SCIENCE.get_node("Actor")
		var bear = BEAR.instance()
		bear.get_node("Actor").set_position(Vector2(4500,800))
		if GlobalResource.game_data['isServer']:
			bear.inServer = true
		GlobalResource.game_data['science'] = SCIENCE.get_node("Actor")
		GlobalResource.game_data['bug'] = BUG.get_node("Actor")
		BUG.get_node("Actor").set_position(Vector2(4000,800))
		SCIENCE.get_node("Actor").set_position(Vector2(4500,1250))
		#$CanvasModulate.add_child(BUG)
		#$CanvasModulate.add_child(SCIENCE)
		$ViewportContainer/Viewport/body_scena.add_child(BUG)
		$ViewportContainer/Viewport/body_scena.add_child(SCIENCE)
		$ViewportContainer/Viewport/body_scena.add_child(bear)
		add_child(gol)



#func _new_data_about_ai(json):
#	ai.set_position(Vector2(json['pos_x'],json['pos_y']))
#	ai.set_rotate(json['rotation'])
#	ai.set_stamina(json['stamina'])
#	ai.set_state(json['state'])
