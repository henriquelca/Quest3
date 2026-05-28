extends Node

const QUESTIONS_FILE = "res://questions_Prof.json"
const QUIZ_SIZE = 3

@onready var canvas_layer = $CanvasLayer
@onready var question_label = $CanvasLayer/PanelContainer/Label
@onready var answer_buttons = [
	$CanvasLayer/PanelContainer2/HBoxContainer/VBoxContainer/Button,
	$CanvasLayer/PanelContainer2/HBoxContainer/VBoxContainer/Button2,
	$CanvasLayer/PanelContainer2/HBoxContainer/VBoxContainer2/Button3,
	$CanvasLayer/PanelContainer2/HBoxContainer/VBoxContainer2/Button4
]

var questions = []
var current_questions = []
var current_question_index = 0

func _ready():
	load_questions()
	connect_buttons()
	hide_buttons()
	canvas_layer.visible = false

func load_questions():
	var file_text = FileAccess.get_file_as_string(QUESTIONS_FILE)

	if file_text.is_empty():
		push_error("Could not load questions file")
		return

	questions = JSON.parse_string(file_text)

	if questions == null:
		push_error("Invalid JSON in questions file")
		questions = []

func connect_buttons():
	for button in answer_buttons:
		button.pressed.connect(on_answer_pressed.bind(button))

func start_quiz():
	if questions.is_empty():
		push_error("No questions loaded")
		return

	canvas_layer.visible = true

	current_questions = questions.duplicate()
	current_questions.shuffle()
	current_questions = current_questions.slice(0, QUIZ_SIZE)

	current_question_index = 0
	show_question()

func show_question():
	if current_question_index >= current_questions.size():
		end_quiz()
		return

	var question_data = current_questions[current_question_index]

	question_label.text = question_data.get("question", "Missing Question")

	var answers = question_data.get("answers", [])

	for i in range(answer_buttons.size()):
		if i < answers.size():
			answer_buttons[i].visible = true
			answer_buttons[i].disabled = false
			answer_buttons[i].text = answers[i].get("text", "")
		else:
			answer_buttons[i].visible = false
			answer_buttons[i].disabled = true

func on_answer_pressed(button):
	current_question_index += 1
	show_question()

func end_quiz():
	canvas_layer.visible = false

func hide_buttons():
	for button in answer_buttons:
		button.visible = false
		button.disabled = true