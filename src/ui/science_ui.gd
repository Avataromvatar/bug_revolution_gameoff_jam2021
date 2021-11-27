extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player
var actor
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func init():
	if GlobalResource.game_data['player_type'] == 'bug':
		actor= GlobalResource.game_data['bug_actor']
		$score.show()
	if GlobalResource.game_data['player_type'] == 'science':
		actor= GlobalResource.game_data['science_actor']
	if GlobalResource.game_data['player_type'] == 'solder':
		for i in GlobalResource.game_data.keys():
			if i.find('solder')>=0 and i.find('actor')>=0:
				actor= GlobalResource.game_data[i]
	player = GlobalResource.game_data['player']
	
	set_process(true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$stamina.text = 'Stamina:  %.1f'%actor.stamina
	$hits.text = 'Hits:  %.1f'%player.hit
	if $score.is_visible_in_tree():
		$score.text = 'Score: %d / %d'%[player.score,player.score_need]
