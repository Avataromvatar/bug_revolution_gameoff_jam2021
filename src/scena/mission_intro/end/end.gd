extends Control


var state7_allLive_text = "Enemy soldiers are defeated.\nThe scientist leaning against the wall breathes wearily and arrives in post shock from what happened. The beetle crawled under the scientist's arm, the scientist responded and stroked the dense, slightly rough chitin of his shell.\nGovernment troops soon arrived, but several groups of attackers managed to escape.\nThe cyberzhook project was recognized as successful, the scientist headed this project and soon the Beetle had brothers and each Beetle had its own Human…\n"
var state8_bugDIEsciLive_text = "Beetle defended his scientist to the last… and he fell in an unequal battle and for this sacrifice the scientist was able to survive ... But for the first time in his life the scientist felt gratuitous support and love ... and grief of loss.\nWe decided to continue the cyber beetle project and our scientist, forgetting about sleep and food, created a new Beetle…"
var state9_bugLiveSciDie_text = "The scientist fell, the beetle could not protect him.\n'It shouldn't be like this,' the Beetle's consciousness screamed, because I only felt its warmth.... And now his hand is cold…\nRegular government troops began to clear the place from the attackers, but several detachments still managed to escape.. The beetle did not know that its own were coming and began to protect the dead scientist, as a result of which the troops retreated and decided to call other scientists to solve this problem. The beetle, seeing on the monitors that it was his own, decided to leave the laboratory. And soon crime began to decrease sharply in the nearest city, ordinary people elevated the Beetle to the rank of hero, and the police announced a hunt for him.\nThe experiment with the cyber beetle was recognized as successful, soon the Beetle's brothers began to hunt for him, but after all the copies disappeared, the project was closed.\nA few years later, crime began to decrease sharply across the country, the Beetles carried retribution bypassing the state's vicious justice. No one, not even the richest criminal, could protect himself from them. There was a panic in the upper circles… Beetles have made statements that they will protect humanity because they love it and as long as there is a system of human oppression by man, they will fight the oppressors.\nSome people began to support them and massively began to teach people about class struggle, capital and socialism. Circles of critical thinking began to appear. And the State staged terror..... The answer to terror was a REVOLUTION!! A NEW SOCIAL REVOLUTION!! A MAN IS A BROTHER TO A MAN AND A BEETLE IS A FRIEND TO A MAN!!!"
var state10_AllDie_text = "This is a fiasco brother......"

func _ready():
	GolMaster.permission = true
	get_tree().paused = false
	if GlobalResource.game_data['game_state']==7:
		$text_frame.start_write_text(state7_allLive_text)
	elif GlobalResource.game_data['game_state']==8:
		$text_frame.start_write_text(state8_bugDIEsciLive_text)
	elif GlobalResource.game_data['game_state']==9:
		$text_frame.start_write_text(state9_bugLiveSciDie_text)
	elif GlobalResource.game_data['game_state']==10 or GlobalResource.game_data['game_state']==11:
		$text_frame.start_write_text(state10_AllDie_text)
	$AudioStreamPlayer.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	GlobalResource.game_data['game_state'] = 1
	
	get_tree().change_scene("res://main.tscn")
	
