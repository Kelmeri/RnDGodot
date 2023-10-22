extends CenterContainer

var save_list : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_pane(1)

func _set_pane(p_no):
	$MainMenu.visible = p_no == 1
	$Options.visible = p_no == 4

# Main menu

func _on_new_game_btn_pressed():
	print_debug("pressed")
	GameState.new_game(GameState.GameDifficulty.GAME_EASY)

func _on_options_btn_pressed():
	_set_pane(4)

func _on_exit_btn_pressed():
	get_tree().quit()

func _on_back_btn_pressed():
	_set_pane(1)
