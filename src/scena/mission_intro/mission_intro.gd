extends Control

export var isDebug =false
var BUG = preload("res://src/character/bug/bug.tscn").instance()
var SCIENCE = preload("res://src/character/science/science.tscn").instance()

var ai
# Called when the node enters the scene tree for the first time.
func _ready():
	if !isDebug:
		if GlobalResource.game_data['player_type'] == 'bug':
			BUG.isClientOn = true
			SCIENCE.isClientOn = false
			BUG.connect("new_data_from_server",self,'_new_data_about_ai')
			ai = SCIENCE
			GlobalResource.game_data['ai_actor_node'] = ai.get_node("Actor")
			GlobalResource.game_data['player_actor_node'] = BUG.get_node("Actor")
		else:
			BUG.isClientOn = false
			SCIENCE.isClientOn = true
			ai = BUG
			SCIENCE.connect("new_data_from_server",self,'_new_data_about_ai')
			GlobalResource.game_data['ai_actor_node'] = ai.get_node("Actor")
			GlobalResource.game_data['player_actor_node'] = SCIENCE.get_node("Actor")
		BUG.set_position(Vector2(500,0))
		SCIENCE.set_position(Vector2(1000,500))
		$CanvasModulate.add_child(BUG)
		$CanvasModulate.add_child(SCIENCE)
	
func _new_data_about_ai(json):
	ai.set_position(Vector2(json['pos_x'],json['pos_y']))
	ai.set_rotate(json['rotation'])
	ai.set_stamina(json['stamina'])
	ai.set_state(json['state'])
