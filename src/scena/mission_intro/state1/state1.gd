extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var text_bug = "I open my eyes. The liquid in which I have been living for a very long time makes it difficult to see, because of it everything becomes greenish. How tired I am... Why can't I get out of here? Why can't I go home? Why did they take me out of all the bugs in the world?\nWow, he's back! The scientist following me is here again! What does he have?.. Marmalade bears? A. I'm sure they're delicious. In fact, the scientist brings them so often that it begins to seem to me that he will soon mutate and he will not need any other food except marmalade at all. And what, will he check on me here? Oh, of course, why would he need a smart radioactive bug when there are cute cats and dogs. Yes, I'm not very handsome, maybe, but I can bring a stick too! I can scratch my belly too! I'm no worse than them! Even better, because they're out there somewhere, and I'm here, very close. Well, turn around, I'm here!\n*An accident happens, the lid of the device opens/ the glass breaks/ the liquid spills out, the beetle runs out*"
var text_science = 'sdfsdfdsfdsfs'
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("life")
	if GlobalResource.game_data['player_type'] == 'bug':
		$text_frame.start_write_text(text_bug)
	else:
		$text_frame.start_write_text(text_science)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://src/scena/mission_intro/gol_mission_intro.tscn") 
