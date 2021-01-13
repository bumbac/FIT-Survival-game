extends Area2D

var items_in_range = {}


func _on_PickUpArea_body_entered(body):
	if body.player == null:
		if body.item_name == "coffee-cup":
			items_in_range[body] = body
			body.player = get_parent()

func _on_PickUpArea_body_exited(body):
	if items_in_range.has(body):
			items_in_range.erase(body)
