extends Control


const Responce = preload("res://scenes/Responce.tscn")
const InputResponce = preload("res://scenes/InputResponce.tscn")

@export var max_lines_remembered: int = 30

var max_scroll_lenght := 0

@onready var command_processor = $CommandProcessor
@onready var hystory_rows = $Background/MarginContainer/Rows/GameInfo/Scroll/HistoryRows
@onready var scroll = $Background/MarginContainer/Rows/GameInfo/Scroll
@onready var scrollbar = scroll.get_v_scroll_bar()


func _ready() -> void:
	scrollbar.connect("changed", Callable(self, "handle_scrollbar_changed"))
	max_scroll_lenght = scrollbar.max_value
	var starting_message = Responce.instantiate()
	starting_message.text = "You find yourself in a house, with no memory of how you got there. You need to find your way out.\n\nYou can type 'help' to see your available commands."
	add_responce_to_game(starting_message)


func handle_scrollbar_changed():
	if max_scroll_lenght != scrollbar.max_value:
		max_scroll_lenght = scrollbar.max_value
		scroll.scroll_vertical = max_scroll_lenght


func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	var input_responce = InputResponce.instantiate()
	var responce = command_processor.process_command(new_text)
	input_responce.set_text(new_text, responce)
	add_responce_to_game(input_responce)


func add_responce_to_game(responce: Control):
	hystory_rows.add_child(responce)
	delete_history_beyond_limit()


func delete_history_beyond_limit():
	if hystory_rows.get_child_count() > max_lines_remembered:
		var rows_to_forget = hystory_rows.get_child_count() - max_lines_remembered
		for i in range(rows_to_forget):
			hystory_rows.get_child(i).queue_free()
