extends Node

@export var questions_file: String = "res://Banco/questions_Prof.json"
const QUIZ_SIZE = 3
const FEEDBACK_TIME = 1.0

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
var current_answers = []
var current_question_index = 0
var score = 0

signal quiz_finished(score: int)

func _ready():
	load_questions()
	connect_buttons()
	hide_buttons()
	canvas_layer.visible = false

func load_questions():
	var file_text = FileAccess.get_file_as_string(questions_file)

	if file_text.is_empty():
		push_error("Could not load questions file: " + questions_file)
		return

	questions = JSON.parse_string(file_text)

	if questions == null:
		push_error("Invalid JSON in questions file: " + questions_file)
		questions = []

func connect_buttons():
	for button in answer_buttons:
		button.pressed.connect(on_answer_pressed.bind(button))

func start_quiz():
	if questions.is_empty():
		push_error("No questions loaded from: " + questions_file)
		return

	canvas_layer.visible = true
	score = 0

	current_questions = questions.duplicate()
	current_questions.shuffle()
	current_questions = current_questions.slice(0, QUIZ_SIZE)

	current_question_index = 0
	show_question()

func show_question():
	if current_question_index >= current_questions.size():
		end_quiz()
		return

	reset_button_colors()

	var question_data = current_questions[current_question_index]
	question_label.text = question_data.get("question", "Missing Question")

	current_answers = question_data.get("answers", []).duplicate()
	current_answers.shuffle()

	for i in range(answer_buttons.size()):
		if i < current_answers.size():
			answer_buttons[i].visible = true
			answer_buttons[i].disabled = false
			answer_buttons[i].text = current_answers[i].get("text", "")
		else:
			answer_buttons[i].visible = false
			answer_buttons[i].disabled = true

func on_answer_pressed(button):
	disable_all_buttons()

	var index = answer_buttons.find(button)
	var answer_data = current_answers[index]
	var is_correct = answer_data.get("correct", false)

	if is_correct:
		score += 1
		button.modulate = Color.GREEN
	else:
		button.modulate = Color.RED
		for i in range(current_answers.size()):
			if current_answers[i].get("correct", false):
				answer_buttons[i].modulate = Color.GREEN

	await get_tree().create_timer(FEEDBACK_TIME).timeout

	current_question_index += 1
	show_question()

func end_quiz():
	canvas_layer.visible = false
	quiz_finished.emit(score)

func hide_buttons():
	for button in answer_buttons:
		button.visible = false
		button.disabled = true

func disable_all_buttons():
	for button in answer_buttons:
		button.disabled = true

func reset_button_colors():
	for button in answer_buttons:
		button.modulate = Color.WHITE
