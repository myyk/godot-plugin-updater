extends RefCounted

## Expected format of config is a JSON file like:
##	{
##		"plugin_name": "plugin_updater",
##		"secs_before_check_for_update": 5,
##		"github_repo": "myyk/godot-plugin-updater",
##		"editor_plugin_meta": "PluginUpdaterEditorPlugin"
##	}

const PLUGIN_NAME: String = "PLUGIN_NAME_PLACEHOLDER" # This is replaced when code is generated
const PLUGIN_MAKER_CONFIG_PATH = "res://plugin-updater.json"
const PLUGIN_USER_CONFIG_PATH_FORMAT = "res://addons/%s/generated/updater/plugin-updater.json"

static func get_user_config() -> Dictionary:
	return _get_config(PLUGIN_USER_CONFIG_PATH_FORMAT % PLUGIN_NAME)

static func get_repo_config() -> Dictionary:
	return _get_config(PLUGIN_MAKER_CONFIG_PATH)

static func _get_config(path: String) -> Dictionary:
	var config = {
		secs_before_check_for_update = 5,
	}
	
	if !FileAccess.file_exists(path):
		push_error("plugin-updater: Needs a config at " + path)
		
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	config.merge(JSON.parse_string(file.get_as_text()), true)
	
	return config
