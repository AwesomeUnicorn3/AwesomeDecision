extends Control
signal timer_finished
export var roll_duration: float = 3.0
var options_array: Array = []
var array_size: int = 0
var previous_answer:int = 0
var last_selected_answer:int = 0
onready var label_2 = $VBoxContainer/Label2



func _ready():
	get_options()


func _on_TheButton_button_up():
	roll_through_options(roll_duration)

func get_options():
	var options_source: String = "res://File1.txt"
	var options_file :File = File.new()
	options_file.open(options_source, File.READ)
	var options_text: String = options_file.get_as_text()
	options_array = options_text.split(":")
	array_size = options_array.size()
	options_file.close()


func select_option() -> int:
	randomize()
	var selected_option: int = rand_range(0, array_size -1)
	while previous_answer == selected_option:
		selected_option = rand_range(0, array_size -1)
		
	previous_answer = selected_option
	return selected_option


func roll_through_options(duration: float):
	var max_time: float = duration

	while duration > 0.0:
		if duration >= max_time * .75:
			set_label_and_wait(0.08)
			yield(self, "timer_finished")
			duration -= 0.08
		elif duration > max_time * .5:
			duration -= 0.12
			set_label_and_wait(0.12)
			yield(self, "timer_finished")
		elif duration > 0.0:
			duration -= 0.2
			set_label_and_wait(0.2)
			yield(self, "timer_finished")
		else:
			duration -= 0.04
			yield(get_tree().create_timer(0.04), "timeout")

	var final_selection: int = select_option()
	while final_selection == last_selected_answer:
		final_selection = select_option()
	last_selected_answer = final_selection
	set_label_text(options_array[final_selection])



func set_label_and_wait(wait_duration:float):
	set_label_text(options_array[select_option()])
	yield(get_tree().create_timer(wait_duration), "timeout")
	emit_signal("timer_finished")


func set_label_text(new_text:String):
	label_2.set_text(new_text)
