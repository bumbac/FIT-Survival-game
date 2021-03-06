extends KinematicBody2D

const SPEED = 1000
var movedir = Vector2(0,0)
var spritedir = "down"
var dist = 0
var prevpos = self.position
var show_inst = false

func _ready():
	self.global_position = Global.player_initial_map_position
	prevpos = self.position


func _physics_process(_delta):
	
		controls_loop()
		movement_loop()
		if prevpos != self.position:
			Global.dist += Vector2(self.position - prevpos).length()
			prevpos = self.position
		spritedir_loop()
		pickup()
		
		if movedir != Vector2(0,0):
			anim_switch("walk")
		else:
			anim_switch("idle")


func controls_loop():
	var LEFT	=	Input.is_action_pressed("ui_left")
	var RIGHT	=	Input.is_action_pressed("ui_right")
	var UP		=	Input.is_action_pressed("ui_up")
	var DOWN	=	Input.is_action_pressed("ui_down")
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)


func movement_loop():
	var motion = movedir.normalized() * SPEED
	move_and_slide(motion, Vector2.ZERO)
	

func spritedir_loop():
	match movedir:
		Vector2(-1,0):
			spritedir="left"
		Vector2(1,0):
			spritedir="right"
		Vector2(0,-1):
			spritedir="up"
		Vector2(0,1):
			spritedir="down"


func anim_switch(animation):
	var newanim = str(animation,spritedir)
	if $anim.current_animation != newanim:
		$anim.play(newanim)


func pickup():
	if $PickUpArea.items_in_range.size() > 0:
		var pickup_item = $PickUpArea.items_in_range.values()[0]
		pickup_item.pick_up_item(self, true)
		$PickUpArea.items_in_range.erase(pickup_item)


func _input(event):
	if get_tree().current_scene.name == '0Gate':
		if $Camera2D/UserInterface/Read.visible:
			if event.is_action_pressed("read"):
				if show_inst:
					show_inst = false
					$Control.hide()
				else:
					show_inst = true
					$Control.show()
		else:
			show_inst = false
			$Control.hide()


func PC_entered(body):
	$Camera2D/UserInterface/PCMusic.show()

func _on_Area2D_body_exited(body):
	$Camera2D/UserInterface/PCMusic.hide()
	$Camera2D/UserInterface/Read.hide()
	
	
func rollup_entered(body):
	$Camera2D/UserInterface/Read.show()
