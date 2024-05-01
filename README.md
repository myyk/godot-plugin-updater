# Godot Plugin Updater

[![License](https://img.shields.io/github/license/myyk/godot-plugin-updater)](https://github.com/myyk/godot-plugin-updater/blob/main/LICENSE)
[![GitHub release badge](https://badgen.net/github/release/myyk/godot-plugin-updater/stable)](https://github.com/myyk/godot-plugin-updater/releases/latest)
[![CI/CD](https://github.com/myyk/godot-plugin-updater/actions/workflows/ci.yml/badge.svg)](https://github.com/myyk/godot-plugin-updater/actions/workflows/ci.yml)

Godot Plugin Updater a Godot plugin for Godot plugin makers to give their plugins an easy in-editor updating. 

## Why was this made?

Publishing new versions of your plugin to the Godot Asset library is slow and not easily automated. There's also no official or mature dependency management system for Godot. There are a few plugins that use similar updating approaches but their update mechanisms aren't easily reusable by other plugin makers.

There is a [proposal (#8451)](https://github.com/godotengine/godot-proposals/issues/8451) to solve this missing of functionality in Godot, but it is understandably difficult to pick a solution because there are a lot of trade-offs.

Having no obligation to make everyone happy, this tool was made to solve the pain for some projects with simple needs. 

## Features

* Small amount of code to integrate into your project.
* Shows the release diff in the editor if there's an update available.
* godot-plugin-updater can easily be updated in the editor through itself.
* Uses semantic versioning.
* Allows users of your plugins to skip an update.

## How does it work?

The plugin installs the updater into your plugin under a folder it creates: `res://asset/<your_plugin>/generated/updater`

This code must be supplied with your release.

Note: do not edit code in `generated/` as it will get deleted and regenerated every time you open your plugin in Godot editor.

You need to hook up a hidden updater window into your plugin that will be displayed when there's an update at start up.

The plugin uses Github tags to know if there's an update by comparing your plugin's `plugin.cfg` version to the latest tag in your configured repo.

## When not to use this?

Some reasons you might not want to use this:

* If you expect users will modifications to your plugin or any other data in your `res://addons/your-plugin` directory. These will be obliterated on updates without prompt.
* Your plugin needs more than a simple delete/replace operation.

## Installation

### Create

It's not necessary to create this config before installing the plugin, but you will have to deactivate/reactivate your plugin after creating it.

In the root of your project create a file called `plugin-updater.json`. (It should be here `"res://plugin-updater.json"`)

It needs these settings:

```
{
	"plugin_name": "your_plugin_director_name",
	"github_repo": "user_or_org/your_plugin_repo_name",
	"editor_plugin_meta": "PluginYourPluginNameEditorPlugin"
}
```

### Install the plugin

You can install it via the Asset Library or [downloading a copy](https://github.com/myyk/godot-plugin-updater/archive/refs/heads/main.zip) from GitHub.

### Edit your main plugin script

In your main plugin script that extends `EditorPlugin` you need to add the update panel that will check for updates and show them to the user when available. Replace `YourEditorPlugin` with what you put into `editor_plugin_meta` and `your_plugin` with what you put in `plugin_name`

    func _enter_tree():
        Engine.set_meta("YourEditorPlugin", self)
        var update_tool: Node = load("res://addons/your_plugin/generated/updater/download_update_panel.tscn").instantiate()
        Engine.get_main_loop().root.call_deferred("add_child", update_tool)

    func _exit_tree():
        if Engine.has_meta("YourEditorPlugin"):
            Engine.remove_meta("YourEditorPlugin")

## Example Installations

I was motivated to add this mainly to support my other plugins. You can see how it's integrated here if you need a working example.

* https://github.com/myyk/godot-playlists/

## plugin-updater.json

### Parameters

#### plugin_name

This needs to exactly match your plugin name in `res://addons/`.

Required, Type: String

#### github_repo

This needs to exactly match your github repo name. Ex: This project is `myyk/godot-plugin-updater`

Required, Type: String

#### editor_plugin_meta

This needs to be any unique string to identify your plugin vs another that may also be using the godot-update-plugin.

Required, Type: String

#### secs_before_check_for_update

The amount of time after editor startup before the plugin check for updates.

Optional, Type: Float, Default: 5

## Requirements

* Your project is in a public Github repo.

* Your plugin is located in `/assets/<plugin_name>/` in your repo.

* You use Semantic Versioning tags like: v1.2.3.

* Godot Plugin Updater **requires at least Godot 4.0**.

## Future Work

* It would be nice to have a nicer looking UI.

* Automated testing, this wasn't easy to test with all the projects involved.

* Please add suggestions as Issues and solutions as Pull Requests!

## Special Thanks

This project heavily borrowed code and design from [MikeSchulze/gdUnit4](https://github.com/MikeSchulze/gdUnit4). Thank you for you're awesome testing tool!

There was more code taken from [nathanhoad/godot_dialogue_manager](https://github.com/nathanhoad/godot_dialogue_manager) and his video https://www.youtube.com/watch?v=oepTYOMoMmc explaining how to build that was helpful too! This is also a great plugin to check out for Character Dialogs!

## License
This project is licensed under the terms of the [MIT license](https://github.com/myyk/godot-plugin-updater/blob/main/LICENSE).
