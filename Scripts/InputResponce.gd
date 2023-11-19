extends VBoxContainer


func set_text(input: String, response: String):
	$InputHistory.text = " > " + input
	$Responce.text = response
