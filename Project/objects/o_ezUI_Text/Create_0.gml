/// @description Setup
/*
@props
x		{real}	Position x
y		{real}	Position y
depth	{int}	Depth (z-index)
text	{str}	Text to draw
font	{ref}	Font to use
color	{real}	Text color
size	{int}	Text size in pixels
alpha	{real}	Text alpha
hAlign	{int}	Text horizontal align
vAlign	{int}	Text vertical align
*/
event_inherited();

ezUI_add_prop("text",	"",							ezui_type_string);
ezUI_add_prop("font",	fnt_ezRoomEditor_default,			ezui_type_any);
ezUI_add_prop("color",	ezui_color_text_primary,	ezui_type_real);
ezUI_add_prop("size",	10,							ezui_type_int);
ezUI_add_prop("alpha",	1.0,						ezui_type_real);
ezUI_add_prop("hAlign",	fa_center,					ezui_type_int);
ezUI_add_prop("vAlign",	fa_center,					ezui_type_int);