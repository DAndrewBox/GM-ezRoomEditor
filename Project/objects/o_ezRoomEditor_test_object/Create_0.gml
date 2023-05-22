/// @description Setup
event_inherited();

name	= "Foo Smith";
desc	= "I Live on a place with a\nloooooooooooooooooooooooooooooooooooooooooooong name";
age		= 2000;
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

ezRoomEditor_add_editable_variables("name",, ezre_type_string);
ezRoomEditor_add_editable_variables("age",, ezre_type_int);
ezRoomEditor_add_editable_variables("desc",, ezre_type_string_long);

ezRoomEditor_add_editable_variables("MESSAGE", true, ezre_type_string_long);
ezRoomEditor_add_editable_variables("COLOR_NO_ALPHA", true, ezre_type_color);
ezRoomEditor_add_editable_variables("COLOR_WITH_ALPHA", true, ezre_type_color_rgba);
ezRoomEditor_add_editable_variables("LIST_VAR", true, ezre_type_array);
ezRoomEditor_add_editable_variables("SPRITE_LIST", true, ezre_type_asset_sprite);
ezRoomEditor_add_editable_variables("SCRIPTS_LIST", true, ezre_type_asset_script);
ezRoomEditor_add_editable_variables("OBJECTS_LIST", true, ezre_type_asset_object);

ezRoomEditor_add_editable_variables("test_options",, ezre_type_array);
ezRoomEditor_add_editable_variables("test_struct_stuff",, ezre_type_struct);

show_debug_overlay(true);

ezRoomEditor_add_ignored_variables("option_selected");