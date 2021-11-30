extends Control


# Declare member variables here. Examples:
# var a = 2

var state1_bug_text = "I wonder if the scientist has thought that I am something more than a simple experiment? Did he reflect on the fact that when he created a biorobot, he accidentally created a personality? Did he think about the fact that I am waiting for attention, support, love? I can think, I can feel, and it's not just a simple matter! Isn't it time for him to understand that I, too, can be hurt, lonely, sad? Every time I try to draw attention to myself, to point out to him what he does not notice in any way, what do I get in response? Only dissatisfied grumbling, complaints of headache and excessive noise... This person does not see that he is one step away, one miserable step away from making a living being happy!"
var state1_science_text = "I am 28 years old, I live with my parents, and no one seems to believe in me. Loving my job is all I have.\nI work for a corporation where they pay me just enough to buy a sweater, popcorn and pasties from Palych. I give part of my salary to my mother, and she pays for communal services. I am her unfulfilled hopes, and I am responsible for it. Every day, listening to her lamentations, I pay with my luck. I am out of luck, in her opinion, in almost everything: I don't have a car, I don't have an apartment, and I don't have a girlfriend, because even those who fell in love with me certainly don't like my mother. It is impossible to bring a girl to my parents' house.\nBut now everything can change. I am on the verge of a successful completion of the experiment. The insect can be a weapon. Can you imagine? A cyber bug is growing in my laboratory: a mutant created for the most dangerous sabotage operations behind enemy lines. Resistant to radiation, with a powerful regeneration, it will become a masterpiece of our department! This bug is my hope to change my life for the better. I have a lot to do: for example, his acid glands are not functioning properly yet, but I will figure it out.\nThe boss promised me a huge bonus if the bug could prove its effectiveness. And I'll spend the money on an apartment. Why do I need my own apartment? I really want a dog. Mom doesn't allow me to have pets, and I so want to give someone my love. It would be great to walk with my dog in a dark park, in the evenings, when the full moon is shining and a fresh wind is blowing. My dog will bark at passersby, protecting me. This is my dream - to live next to someone who needs me and who will always be dear to me. And I'm just one step away from it being real..."

var state2_bug_text ='"Pain... the pain stops," the beetle thought in surprise. For him, pain has long been something that means perfection, he has long taken it for granted… The sparkling containment field shuddered and went out. The beetle fell to the cold floor of the room.\n"Am I free? But the mutation is not over. So my scientist will not be satisfied ...", the beetle was not happy with this thought. “I need to urgently find food and finish the mutation, maybe then I can prove to the scientist that I am worth something and I can and he will treat me differently and maybe even we will make friends and play together...'
var state2_science_text ="'Damn it!! What have I done!! …...' the inner voice of the scientist shouted, cold sweat streamed down his body. 'So let's get together! If the generator is turned off, then the beetle ... is released' the scientist turned pale, what can he expect from him?.\nGathering his will into a fist, he pulled out a flashlight and a special stunner from the desk drawer, this is not the first time when the test subject runs away, the last time the chief scientist was suspended from work because of this. The scientist swallowed remembering this.\n'Okay, I'll catch it quickly and everything will be fine'"

var state2_common = 'Deep into the night.\nIn the cyber biological laboratory, only a young scientist and his experimental beetle, a cyber mutant, who is in a stasis field under the influence of radiation, remained.\nScientist:\n"The activity of acid glands is increasing, but it is not yet sufficient to be used as a weapon… Can raise the tension? Just a little bit.”\n\nBahhhh there is a clap and almost all the devices go out. Red evacuation lights turn on. The main reactor is out of order...\n\n'
var state:int = 1
var substate:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalResource.game_data.has('game_state'):
		state = GlobalResource.game_data['game_state']
	else:
		GlobalResource.game_data['game_state'] = state
	$State1_bug.hide()
	$State1_science.hide()
	$State2.hide()
	if state == 1:
		_play_state1()
	elif state == 2:
		_play_state2()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#PreIntro
func _play_state1():
	
	$text_frame.text = ''
	if GlobalResource.game_data['player_type'] == 'bug':
		$State1_bug/audio_state1_bug.play()
		$State1_bug.show()
		$State1_bug/AnimationPlayer.play("life")
		$text_frame.start_write_text(state1_bug_text)
	else:
		$State1_science/audio_state1_sci.play()
		$State1_science.show()
		$text_frame.start_write_text(state1_science_text)

func _play_state2():
	$State1_science/audio_state1_sci.stop()
	$State1_bug/audio_state1_bug.stop()
	$State2/AnimationPlayer.play("life")
	if substate == 0:
		$State1_bug.hide()
		$State1_science.hide()
		$State2.show()
		$text_frame.text = ''
		$text_frame.start_write_text(state2_common)
		yield(get_tree().create_timer(2.0), "timeout")
		$State2/audio_reactor_fall.play()
		substate = 1
	elif substate == 1:
		substate = 2
		if GlobalResource.game_data['player_type'] == 'bug':
			$text_frame.start_write_text($text/state2_bug.text) #state2_bug_text)
		else:
			$text_frame.start_write_text($text/state2_sci.text) #state2_science_text)	



func _on_Button_pressed():
	if state == 1:
		state = 2
		GlobalResource.game_data['game_state'] = 2
		_play_state2()
	elif state == 2 and substate==1:
		_play_state2()
	elif state == 2 and substate ==2:
		substate = 3
	elif state == 2 and substate ==3:
			GlobalResource.game_data['game_state'] = 3
			get_tree().change_scene("res://src/scena/mission_intro/gol_mission_intro.tscn") 


func _on_audio_state1_bug_finished():
	if state == 1:
		$State1_bug/audio_state1_bug.play()
