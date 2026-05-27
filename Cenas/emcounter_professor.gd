extends Node

const QUESTIONS_FILE_PATH = "res://questions_Prof.json"
const QUIZ_SIZE = 3

@onready var canvas_layer = $CanvasLayer
@onready var question_label = $CanvasLayer/PanelContainer/Label
@onready var answer_buttons = [
	$CanvasLayer/PanelContainer2/HBoxContainer/VBoxContainer/Button,
	$CanvasLayer/PanelContainer2/HBoxContainer/VBoxContainer/Button2,
	$CanvasLayer/PanelContainer2/HBoxContainer/VBoxContainer2/Button3,
	$CanvasLayer/PanelContainer2/HBoxContainer/VBoxContainer2/Button4
]

var questions := []
var selected_questions := []
var current_index := 0
var rng := RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	_load_questions()
	for button in answer_buttons:
		button.connect("pressed", Callable(self , "_on_answer_button_pressed").bind(button))
	_hide_all_answer_buttons()

func _load_questions():
	var file = FileAccess.open(QUESTIONS_FILE_PATH, FileAccess.READ)
	if file == null:
		push_error("Could not open questions file: %s" % QUESTIONS_FILE_PATH)
		return
	var content = file.get_as_text()
	file.close()
	var parsed = JSON.parse_string(content)
	# JSON.parse_string may return the parsed Array directly or a Dictionary-like parse result
	if typeof(parsed) == TYPE_ARRAY:
		questions = parsed
		return
	if typeof(parsed) == TYPE_DICTIONARY:
		# Godot JSON parse result object: check for error and result
		if parsed.has("error") and parsed.error != OK:
			push_error("JSON parse error in questions file: %s" % parsed.error_string)
			return
		if not parsed.has("result") or typeof(parsed.result) != TYPE_ARRAY:
			push_error("Questions file root must be an array")
			return
		questions = parsed.result
		return
	# Unexpected parse return type
	push_error("Unexpected JSON parse result type: %s" % typeof(parsed))

func start_quiz():
	if questions.is_empty():
		push_error("No questions loaded for quiz")
		return
	_prepare_random_questions()
	current_index = 0
	_show_current_question()

func _prepare_random_questions():
	selected_questions.clear()
	var indices = []
	for i in range(questions.size()):
		indices.append(i)
	# Use Array.shuffle() to randomize indices
	indices.shuffle()
	for i in range(min(QUIZ_SIZE, indices.size())):
		selected_questions.append(questions[indices[i]])

func _show_current_question():
	if current_index >= selected_questions.size():
		_end_quiz()
		return
	var question_data = selected_questions[current_index]
	question_label.text = question_data.get("question", "Pergunta")
	var answers = question_data.get("answers", [])
	for i in range(answer_buttons.size()):
		if i < answers.size():
			answer_buttons[i].text = str(answers[i].get("text", ""))
			answer_buttons[i].visible = true
			answer_buttons[i].disabled = false
		else:
			answer_buttons[i].visible = false
			answer_buttons[i].disabled = true

func _on_answer_button_pressed(button):
	current_index += 1
	_show_current_question()

func _end_quiz():
	canvas_layer.visible = false

func _hide_all_answer_buttons():
	for button in answer_buttons:
		button.visible = false
		button.disabled = true
