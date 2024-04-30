# GdUnit generated TestSuite
class_name UpdaterHttpClientTest
extends GdUnitTestSuite

# Adapted from https://github.com/MikeSchulze/gdUnit4/blob/99b7c32/addons/gdUnit4/test/update/GdMarkDownReaderTest.gd

# TestSuite generated from
const __source = 'res://addons/plugin_updater/generated/updater/updater_markdown_reader.gd'
const UpdaterHttpClient = preload("res://addons/plugin_updater/generated/updater/updater_http_client.gd")

var _reader = preload(__source).new()
var _client :UpdaterHttpClient


func before():
	_client = UpdaterHttpClient.new()
	add_child(_client)
	_reader.set_http_client(_client)


func after():
	_client.queue_free()


func test_tobbcode() -> void:
	var source := resource_as_string("res://test/resources/markdown_example.txt")
	var expected := resource_as_string("res://test/resources/bbcode_example.txt")
	assert_str(await _reader.to_bbcode(source)).is_equal(expected)


func test_tobbcode_table() -> void:
	var source := resource_as_string("res://test/resources/markdown_table.txt")
	var expected := resource_as_string("res://test/resources/bbcode_table.txt")
	assert_str(await _reader.to_bbcode(source)).is_equal(expected)


func test_tobbcode_html_headers() -> void:
	var source := resource_as_string("res://test/resources/html_header.txt")
	var expected := resource_as_string("res://test/resources/bbcode_header.txt")
	assert_str(await _reader.to_bbcode(source)).is_equal(expected)


func test_tobbcode_md_headers() -> void:
	var source := resource_as_string("res://test/resources/md_header.txt")
	var expected := resource_as_string("res://test/resources/bbcode_md_header.txt")
	assert_str(await _reader.to_bbcode(source)).is_equal(expected)


func test_tobbcode_list() -> void:
	assert_str(await _reader.to_bbcode("- item")).is_equal("[img=12x12]res://addons/plugin_updater/generated/updater/assets/dot1.png[/img] item\n")
	assert_str(await _reader.to_bbcode("  - item")).is_equal("   [img=12x12]res://addons/plugin_updater/generated/updater/assets/dot2.png[/img] item\n")
	assert_str(await _reader.to_bbcode("    - item")).is_equal("      [img=12x12]res://addons/plugin_updater/generated/updater/assets/dot1.png[/img] item\n")
	assert_str(await _reader.to_bbcode("      - item")).is_equal("         [img=12x12]res://addons/plugin_updater/generated/updater/assets/dot2.png[/img] item\n")


func test_to_bbcode_embeded_text() -> void:
	assert_str(await _reader.to_bbcode("> some text")).is_equal("[img=50x14]res://addons/plugin_updater/generated/updater/assets/embedded.png[/img][i] some text[/i]\n")


func test_process_image() -> void:
	#regex("!\\[(.*?)\\]\\((.*?)(( )+(.*?))?\\)")
	var reg_ex :RegEx = _reader.md_replace_patterns[24][0]

	# without tooltip
	assert_str(await _reader.process_image(reg_ex, "![alt text](res://test/resources/icon48.png)"))\
		.is_equal("[img]res://test/resources/icon48.png[/img]")
	# with tooltip
	assert_str(await _reader.process_image(reg_ex, "![alt text](res://test/resources/icon48.png \"Logo Title Text 1\")"))\
		.is_equal("[img]res://test/resources/icon48.png[/img]")
	# multiy lines
	var input := """
		![alt text](res://test/resources/icon48.png)

		![alt text](res://test/resources/icon23.png \"Logo Title Text 1\")

		""".dedent()
	var expected := """
		[img]res://test/resources/icon48.png[/img]

		[img]res://test/resources/icon23.png[/img]

		""".dedent()
	assert_str(await _reader.process_image(reg_ex, input))\
		.is_equal(expected)


func test_process_image_by_reference() -> void:
	#regex("!\\[(.*?)\\]\\((.*?)(( )+(.*?))?\\)")
	var reg_ex :RegEx = _reader.md_replace_patterns[23][0]
	var input := """
		![alt text1][logo-1]

		[logo-1]:https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"

		![alt text2][logo-1]

		""".dedent()

	var expected := """
		![alt text1](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png)


		![alt text2](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png)

		""".replace("\r", "").dedent()

	# without tooltip
	assert_str(_reader.process_image_references(reg_ex, input))\
		.is_equal(expected)


func test_process_external_image_save_as_png() -> void:
	var input := """
		[img]https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png[/img]
		[img]https://github.com/MikeSchulze/gdUnit4/assets/347037/3205c9f1-1746-4716-aa6d-e3a1808b761d[/img]
		""".dedent()

	var output := await _reader._process_external_image_resources(input)
	assert_str(output).is_equal("""
		[img]res://cached/updater/icon48.png[/img]
		[img]res://cached/updater/3205c9f1-1746-4716-aa6d-e3a1808b761d.png[/img]
		""".dedent())
	assert_file("res://cached/updater/icon48.png").exists()
	assert_file("res://cached/updater/3205c9f1-1746-4716-aa6d-e3a1808b761d.png").exists()
