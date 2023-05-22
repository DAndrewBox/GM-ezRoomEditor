/// @description Setup
/*
@props
x					{real}		Position x
y					{real}		Position y
depth				{real}		Depth

width				{real}		Modal width
height				{real}		Modal height

inputText			{str}		Text string
inputTextFont		{ref}		Text font
inputTextPlaceholder{str}		Placeholder text
inputTextMaxChars	{int}		Max quantity of chars allowed on input
inputTextCharset	{int}		Text charset to allow

inputEnabled		{bool}		Enable input for writting
inputUseBackground	{bool}		Enable input background
inputUseBorders		{bool}		Enable input borders

inputSyncInstance	{instance}	Instance that will be sync into the input.
inputSyncVariable	{str}		Variable to sync from inputSyncInstance (Requires inputSyncInstance to exists)
inputSyncType		{int}		Type of the sync inputSyncVariable to import from inputSyncInstance

@callbacks
onFocus				{callbale}	Callback when start focus on input.
onChange			{callable}	Callback to use when text on input changed.
onEnter				{callable}	Callback to use when user press enter.
*/
event_inherited();

ezUI_add_prop("width",					200,					ezui_type_real);
ezUI_add_prop("height",					16,						ezui_type_real);

ezUI_add_prop("inputText",				"",						ezui_type_string);
ezUI_add_prop("inputTextFont",			fnt_ezRoomEditor_default,		ezui_type_any);
ezUI_add_prop("inputTextPlaceholder",	"Type here...",			ezui_type_string);
ezUI_add_prop("inputTextMaxChars",		32,						ezui_type_int);
ezUI_add_prop("inputTextCharset",		ezui_charset_all,		ezui_type_string);

ezUI_add_prop("inputLabel",				"",						ezui_type_string);

ezUI_add_prop("inputEnabled",			true,					ezui_type_bool);
ezUI_add_prop("inputUseBackground",		true,					ezui_type_bool);
ezUI_add_prop("inputUseBorders",		true,					ezui_type_bool);

ezUI_add_prop("onFocus",				noone,					ezui_type_callable);
ezUI_add_prop("onChange",				noone,					ezui_type_callable);
ezUI_add_prop("onEnter",				noone,					ezui_type_callable);

ezUI_add_prop("inputSyncInstance",		noone,					ezui_type_instance);
ezUI_add_prop("inputSyncVariable",		"",						ezui_type_string);
ezUI_add_prop("inputSyncType",			ezui_type_string,		ezui_type_int);

t_backspace = 0;
t_backspace_hold = 0;
t_pointer = 0;
state = __EZUI_INPUT_STATE.DEFAULT;