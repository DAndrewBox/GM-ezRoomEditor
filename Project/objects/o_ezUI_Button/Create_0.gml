/// @description Setup
/*
@props
x				{real}		Position x
y				{real}		Position y
depth			{real}		Depth
width			{real}		Button width
height			{real}		Button height
color			{real}		Button color
sprite			{ref}		Button sprite (must use nine-slices)
alpha			{real}		Button alpha
text			{str}		Text string
textColor		{real}		Text color
textFont		{ref}		Text font
textSize		{real}		Text size

@internal
styleOnHover	{struct}	Props on Hover
styleOnFocus	{struct}	Props on Hover

@callbacks
onClick
*/
event_inherited();

ezUI_add_prop("width",		96,							ezui_type_real);
ezUI_add_prop("height",		32,							ezui_type_real);

ezUI_add_prop("color",		ezui_color_text_secondary,	ezui_type_real);
ezUI_add_prop("alpha",		1.0,						ezui_type_real);
ezUI_add_prop("sprite",		noone,						ezui_type_any);

ezUI_add_prop("text",		"",							ezui_type_string);
ezUI_add_prop("textSize",	10,							ezui_type_int);
ezUI_add_prop("textFont",	fnt_ezRoomEditor_default,			ezui_type_any);
ezUI_add_prop("textColor",	ezui_color_text_primary,	ezui_type_real);

ezUI_add_prop("onClick",	ezUI_button_ev_onClick,		ezui_type_callable);

state = __EZUI_BUTTON_STATE.DEFAULT;