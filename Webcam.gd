extends Node2D

var camera_feed: CameraFeed
var camera_texture: CameraTexture = CameraTexture.new()

func _ready():
	# Ensure the CameraServer has at least one feed
	if CameraServer.get_feed_count() > 0:
		camera_feed = CameraServer.get_feed(0)  # Get the first camera feed
		
		# Ensure the feed is available
		if camera_feed and camera_feed.is_active():
			camera_texture.feed = camera_feed
			camera_texture.set_active(true)
			
			# Assuming you have a TextureRect node in your scene to display the camera feed
			$TextureRect.texture = camera_texture
