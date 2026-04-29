extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if body.has_method("prompt_interaction"):
		# Prompt interaction takes a string to have prompted
		body.prompt_interaction("Delve")

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
		
	if body.has_method("remove_prompt"):
		body.remove_prompt()
