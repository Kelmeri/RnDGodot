extends Node3D

var multiplayer_peer = ENetMultiplayerPeer.new()

const PORT = 9999
const ADDRESS = "172.24.18.74"

var connected_peer_ids = []
var local_player_character

@rpc
func on_qr_read(i):
	if i == 1:
		$"../CardA".visible = true
		$"../CardB".visible = false
		$"../CardC".visible = false
	if i == 2:
		$"../CardA".visible = false
		$"../CardB".visible = true
		$"../CardC".visible = false
	if i == 3:
		$"../CardA".visible = false
		$"../CardB".visible = false
		$"../CardC".visible = true
		
	print("Cool")

func add_player_character(peer_id):
	connected_peer_ids.append(peer_id)
	var player_character = preload("res://player_character.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)
	if peer_id == multiplayer.get_unique_id():
		local_player_character = player_character

@rpc	
func add_newly_connected_player_character(new_peer_id):
	add_player_character(new_peer_id)
	
@rpc
func add_previously_connected_player_characters(peer_ids):
	for peer_id in peer_ids:
		add_player_character(peer_id)

#func _on_message_input_text_submitted(new_text):
#	local_player_character.rpc("display_message", new_text)
#	$MessageInput.text = ""
#	$MessageInput.release_focus()


func _on_host_btn_pressed():
	$Screen/Viewport/Network/VBoxContainer/NetworkInfo/NetworkSide.text = "Server"
	$Screen/Viewport/Network/VBoxContainer/VBoxContainer.visible = false
	multiplayer_peer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	$Screen/Viewport/Network/VBoxContainer/NetworkInfo/UniquePeerID.text = str(multiplayer.get_unique_id())
	
	add_player_character(1)
	
	multiplayer_peer.peer_connected.connect(
		func(new_peer_id):
			await get_tree().create_timer(1).timeout
			rpc("add_newly_connected_player_character", new_peer_id)
			rpc_id(new_peer_id, "add_previously_connected_player_characters", connected_peer_ids)
			add_player_character(new_peer_id)
	)


func _on_join_btn_pressed():
	$Screen/Viewport/Network/VBoxContainer/NetworkInfo/NetworkSide.text = "Client"
	$Screen/Viewport/Network/VBoxContainer/VBoxContainer.visible = false
	multiplayer_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = multiplayer_peer
	$Screen/Viewport/Network/VBoxContainer/NetworkInfo/UniquePeerID.text = str(multiplayer.get_unique_id())


func _on_function_pointer_qr_read(i):
	print("i: ", i)
	print("yay")
	
	on_qr_read(i)
