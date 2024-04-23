@tool
extends EditorPlugin

const UpdaterConfig = preload("res://addons/plugin_updater/core/updater_config.gd")
const DEBUG_MODE = false

func _enter_tree():
	var config = UpdaterConfig.get_repo_config()
	_install_to_plugin(config.plugin_name)

	# Add auto-update functionality for plugin_updater itself (not the plugin being updated, that needs similar code)
	if Engine.is_editor_hint():
		Engine.set_meta("PluginUpdaterEditorPlugin", self)
		var update_tool: Node = load("res://addons/plugin_updater/generated/updater/download_update_panel.tscn").instantiate()
		Engine.get_main_loop().root.call_deferred("add_child", update_tool)

func _exit_tree():
	if Engine.has_meta("PluginUpdaterEditorPlugin"):
		Engine.remove_meta("PluginUpdaterEditorPlugin")


func _install_to_plugin(plugin_name: String):
	var err: Error = OK
	# Copy addons/plugin_updater/core as addons/<plugin_name>/generated/updater
	var source_path = "res://addons/plugin_updater/core/"
	var target_path = "res://addons/%s/generated/updater/" % plugin_name
	
	if DirAccess.dir_exists_absolute(target_path):
		err = OS.move_to_trash(ProjectSettings.globalize_path(target_path))
		if err != OK:
			push_error("plugin_updater: could not remove previous install, error = " + str(err))

	err = DirAccess.make_dir_recursive_absolute(target_path)
	if err != OK:
		push_error("plugin_updater: error making directory, error = " + str(err))

	err = _recursive_copy(source_path, target_path)
	if err != OK:
		push_error("plugin_updater: error copying files, error = " + str(err))

	# Copy the config over
	err = DirAccess.copy_absolute(UpdaterConfig.PLUGIN_MAKER_CONFIG_PATH, UpdaterConfig.PLUGIN_USER_CONFIG_PATH_FORMAT % plugin_name)
	if err != OK:
		push_error("plugin_updater: error copying config file, error = " + str(err))

	# Copy in plugin name so we can use relative paths
	replace_string_in_file(target_path + "updater_config.gd", "PLUGIN_NAME_PLACEHOLDER", plugin_name)

func _recursive_copy(from: String, to: String, chmod_flags: int = -1) -> Error:
	var from_dir = DirAccess.open(from)
	var to_dir = DirAccess.open(to)
	if from_dir:
		from_dir.list_dir_begin()
		var file_name = from_dir.get_next()
		while file_name != "":
			if from_dir.current_is_dir():
				if DEBUG_MODE:
					print("Copying directory: " + file_name)
				if !to_dir.dir_exists(file_name):
					to_dir.make_dir(file_name)
				var err = _recursive_copy(from+file_name+"/", to+file_name+"/")
				if err != OK:
					return err
			else:
				if DEBUG_MODE:
					print("Copying file: %s -> %s" % [from+file_name, to+file_name])
				var err = DirAccess.copy_absolute(from+file_name, to+file_name)
				if err != OK:
					return err
			file_name = from_dir.get_next()
			
		return OK
	else:
		return from_dir.get_open_error()

func replace_string_in_file(file_path: String, old_string: String, new_string: String) -> void:
	var source := FileAccess.open(file_path, FileAccess.READ)
	var content := source.get_as_text().replace(old_string, new_string)
	var dest := FileAccess.open(file_path, FileAccess.WRITE)
	dest.store_string(content)
