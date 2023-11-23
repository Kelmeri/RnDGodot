extends CenterContainer

var multiplayer_peer = ENetMultiplayerPeer.new()

const PORT = 9999
const ADDRESS = "127.0.0.1"

var connected_peer_ids = []

var save_list : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_pane(1)

func _set_pane(p_no):
	$VBoxContainer/MainMenu.visible = p_no == 1
#	$VBoxContainer/Options$Options.visible = p_no == 4

# Main menu
func _on_host_pressed():
	$VBoxContainer/NetworkInfo/NetworkSide.text = "Server"
#	$Menu.visible = false
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	$VBoxContainer/NetworkInfo/UniquePeerID.text = str(multiplayer.get_unique_id())

	multiplayer_peer.peer_connected.connect(
		func(new_peer_id):
			await get_tree().create_timer(1).timeout
			rpc("add_newly_connected_player_character", new_peer_id)
			rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
			#add_player_character(new_peer_id)
	)

func _on_join_pressed():
	$VBoxContainer/NetworkInfo/NetworkSide.text = "Client"
#	$Menu.visible = false
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	$VBoxContainer/NetworkInfo/UniquePeerID.text = str(multiplayer.get_unique_id())

func _on_new_game_btn_pressed():
	print_debug("pressed")
	GameState.new_game(GameState.GameDifficulty.GAME_EASY)

#func _on_options_btn_pressed():
#	_set_pane(4)

func _on_exit_btn_pressed():
	get_tree().quit()

#func _on_back_btn_pressed():
#	_set_pane(1)


