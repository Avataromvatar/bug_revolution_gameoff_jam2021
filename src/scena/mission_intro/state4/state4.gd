extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#if data['info']=='bugWIN':
#	GlobalResource.game_data['game_state'] = 4
#if data['info']=='sciWIN':
#	GlobalResource.game_data['game_state'] = 5

var state4_bugWin_text = "Beetle:\n I mutated. My acid glands are working at full capacity. My scientist will be satisfied when I show him how I can produce acid now....\nThe triumph of victory... was drowned out by a security siren. Someone turned on video from the camera on all active terminals.....\nIn the video, the security forces of the complex are trying to repel the armored soldiers, but they are simply crushed. The attackers do not spare anyone.....\nThe scientist is trembling and I feel the fear of death filling him.\nI went up to him and buried my face in his legs and spat acid, which immediately began to melt the floor.\nDistracted from his fear, the scientist sat down and began to examine the acid\nWow, you still could, he said\nI grated confirming his words, then jerked my head towards the cameras and spat again…\nDo you want to fight?, the scientist patted me on the back and salt water dripped from his eyes.\nWell, we have nothing to catch with them, it will kill in any case, and here I just saw a prototype with a laser rifle from another department, charged on a nuclear battery. Let's go give our lives as dearly as possible."
var state5_sciWin_text = "Scientist:\n The bug is caught. Now maybe they will forget about this incident with the reactor.\nThe triumph of victory... was drowned out by a security siren. Someone turned on video from the camera on all active terminals.....\nIn the video, the security forces of the complex are trying to repel the armored soldiers, but they are simply crushed, the attackers do not spare anyone .....\nThe scientist looks at the video, fear and will struggle in it.\nOne of the attackers approaches the terminal and just opens it and takes out the hard drives.. 'They came for data, scientists are not spared, and that means I have nothing to catch' the scientist thought.\nThe scientist looked at the beetle, turned off the stasis network and sat down and stroked the fruit of his labor, tears dripped from his eyes. Surprisingly, the beetle grated something and leaned forward to the hand like a cat or a dog.\nThere are bad uncles coming, they want to kill us, but we won't give up so easily, right?, the beetle nodded. 'Does he really understand me?', a thought flashed through the scientist's mind, but immediately he threw this thought away, then everything later...\nThe scientist called the beetle to a large nuclear battery and called the beetle. Removing the wires from the battery, the scientist found a charging prototype of a laser automaton on it, an experimental development of another department, this finding breathed confidence into him. Connecting the wires from the battery to the beetle, he gave a discharge. She smelled fried, the beetle spat out caustic acid from the discharge and pain and hissed, the scientist began to calm him down.\nI'm sorry it was necessary to finish the mutation and not the fact that it worked, but it was necessary to try and I'm glad that you're alive. Let's go give our lives as dearly as possible.\nThe scientist took the machine gun and, full of determination, prepared for battle ..\nAn explosion was heard in the common room, so they are already here ......."
# Called when the node enters the scene tree for the first time.
func _ready():
	GolMaster.permission = true
	if GlobalResource.game_data['game_state']==4:
		$text_frame.start_write_text($text/state4_bug.text)#  state4_bugWin_text)
	elif GlobalResource.game_data['game_state']==5:
		$text_frame.start_write_text($text/state4_sci.text)# state5_sciWin_text)
	yield(get_tree().create_timer(2.0), "timeout")
	$AudioStreamPlayer.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	GlobalResource.game_data['game_state'] = 6
	get_tree().change_scene("res://src/scena/mission_intro/fighting/mission_fighting.tscn")
	
