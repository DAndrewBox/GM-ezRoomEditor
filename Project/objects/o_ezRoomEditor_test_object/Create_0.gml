/// @description Setup
event_inherited();

name	= "Foo Smith";
desc	= "I Live on a place with a\nloooooooooooooooooooooooooooooooooooooooooooong name";
age		= 20;
test_options = [false, true];
test_struct_stuff = {
	short_string:	"This is a short string.",
	long_string:	"This is a loooooooooooooooooooong string, I hope this is more than 64 chars long so i can test it right.",
	int:			16,
	float:			0.25,
	boolean:		true,
	array:			["hi", "welcome", "to", "chilli's"],
	another_struct:	{
		this: "is",
		another: "struct",
	},
}
option_selected = true;

ezRoomEditor_add_editable_variables("name", ezre_type_string);
ezRoomEditor_add_editable_variables_with_slider("age", [0, 100], ezre_type_int);
ezRoomEditor_add_editable_variables("desc", ezre_type_string_long);

ezRoomEditor_add_editable_variables("MESSAGE", ezre_type_string_long, true);
ezRoomEditor_add_editable_variables("COLOR_NO_ALPHA", ezre_type_color, true);
ezRoomEditor_add_editable_variables("COLOR_WITH_ALPHA", ezre_type_color_rgba, true);
ezRoomEditor_add_editable_variables("LIST_VAR", ezre_type_array, true);
ezRoomEditor_add_editable_variables("SPRITE_LIST", ezre_type_asset_sprite, true);
ezRoomEditor_add_editable_variables("SCRIPTS_LIST", ezre_type_asset_script, true);
ezRoomEditor_add_editable_variables("OBJECTS_LIST", ezre_type_asset_object, true);
ezRoomEditor_add_editable_variables("AUDIO_LIST", ezre_type_asset_audio, true);

ezRoomEditor_add_editable_variables("test_options", ezre_type_array);
ezRoomEditor_add_editable_variables("test_struct_stuff", ezre_type_struct);

show_debug_overlay(true);

ezRoomEditor_add_ignored_variables("option_selected");