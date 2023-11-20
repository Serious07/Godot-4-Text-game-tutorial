extends Node


signal response_generated(response_text)

var current_room = null


func initialize(starting_room):
	change_room(starting_room)


func process_command(input: String) -> String:
	var words = input.split(" ", false)
	if words.size() == 0:
		return "Error: no words were parsed."
	
	var first_word = words[0].to_lower()
	var second_word = ""
	
	if words.size() > 1:
		second_word = words[1].to_lower()
		
	match first_word:
		"go":
			return go(second_word)
		"help":
			return help()
		_:
			return "Unrecognized command - please try again. \nUse help command to see available game commands."

func go(second_word: String) -> String:
	if second_word.is_empty():
		return "Go where?"
	
	return "You go %s" % second_word


func help() -> String:
	return "You can use these commands: go [location], help"


func change_room(new_room : Room):
	current_room = new_room
	var strings = PackedStringArray([
		"You are now in: " + new_room.room_name + ". It is " + new_room.room_description + "\n",
		"Exits: " + "\n"
	])
	emit_signal("response_generated", "".join(strings))
