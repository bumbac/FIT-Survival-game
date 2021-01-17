extends KinematicBody2D

export(Array, String) var dialog
var notes_length = 0
var notes_index = 0
var entered = false
var dialog_index = 0
var quest_started = false
var has_keyboard = Global.keyboard

func _ready():
	notes_length = $fileread.text.size()
	$Dialogue/Popup/Panel.set_global_position(Vector2(3800, 1800))

func _process(_delta):
	if entered and Input.is_action_just_pressed("ui_accept"):
		entered = false
		if dialog_index == 0:
			if quest_started:
				print("started")
				if has_keyboard:
					notes_index = 36
					winGame()
				else:
					notes_index = 37
			else:
				notes_index = 35
				get_parent().dialog_index = 1
				$TimerLecture.stop()
				get_parent().show_choice()
		if dialog_index == 13:
			notes_index = 37
			$TimerLecture.stop()
			return
		dialogue($fileread.text[notes_index])


func dialogue(text):
	$Dialogue/Popup.show()
	$Dialogue/Popup/Panel/RichTextLabel.text = text

func _on_TimerLecture_timeout():
	if notes_index < notes_length - 2:
		dialogue($fileread.text[notes_index])
		notes_index = notes_index + 1
	else:
		notes_index = 0


func _on_Area2D_body_entered(_body):
	entered = true


func _on_Area2D_body_exited(_body):
	entered = false


func winGame():
	pass