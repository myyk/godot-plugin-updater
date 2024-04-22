extends RefCounted

## TODO: Placeholder config

static func get_user_config() -> Dictionary:
	var user_config: Dictionary = {
		plugin_name = "plugin_updater",
		secs_before_check_for_update = 5,
		github_repo = "myyk/godot-playlists",
		editor_plugin_meta = "PlaylistsEditorPlugin", #TODO: try to eliminate this one
	}

	#if FileAccess.file_exists(DialogueConstants.USER_CONFIG_PATH):
		#var file: FileAccess = FileAccess.open(DialogueConstants.USER_CONFIG_PATH, FileAccess.READ)
		#user_config.merge(JSON.parse_string(file.get_as_text()), true)

	return user_config
