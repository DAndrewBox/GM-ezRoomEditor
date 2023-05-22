/// @description Setup
/*
@props
x					{real}		Position x
y					{real}		Position y
depth				{real}		Depth

width				{real}		Modal width
height				{real}		Modal height

modalColor			{real}		Modal background color
modalSprite			{ref}		Modal sprite (must use nine-slices)
modalAlpha			{real}		Modal alpha

modalText			{str}		Text string
modalTextAlign		{real}		Text horizontal align
modalTextColor		{real}		Text color
modalTextSize		{real}		Text size
modalTextFont		{ref}		Text font

titleBarEnabled		{bool}		Use TitleBar
titleBarHeight		{real}		TitleBar height
titleBarColor		{real}		TitleBar color
titleBarCloseButton	{bool}		Use close button on TitleBar
titleBarGrabEnabled	{bool}		Modal can be grab from titlebar

titleBarText		{str}		TitleBar text
titleBarTextCenter	{bool}		TitleBar text on center (true: centered | false: left-align)
titleBarTextColor	{real}		TitleBar text color
titleBarTextSize	{real}		TitleBar text size
titleBarTextFont	{ref}		TitleBar text font

@callbacks
onClose
*/
event_inherited();

ezUI_add_prop("width",					250,								ezui_type_real);
ezUI_add_prop("height",					200,								ezui_type_real);
ezUI_add_prop("modalColor",				ezui_color_background_secondary,	ezui_type_real);
ezUI_add_prop("modalSprite",			noone,								ezui_type_any);
ezUI_add_prop("modalAlpha",				1.0,								ezui_type_real);

ezUI_add_prop("modalText",				"",									ezui_type_string);
ezUI_add_prop("modalTextAlign",			fa_center,							ezui_type_real);
ezUI_add_prop("modalTextColor",			ezui_color_text_primary,			ezui_type_real);
ezUI_add_prop("modalTextSize",			10,									ezui_type_int);
ezUI_add_prop("modalTextFont",			fnt_ezRoomEditor_default,					ezui_type_any);

ezUI_add_prop("titleBarEnabled",		true,								ezui_type_bool);
ezUI_add_prop("titleBarHeight",			16,									ezui_type_int);
ezUI_add_prop("titleBarColor",			ezui_color_background_primary,		ezui_type_real);
ezUI_add_prop("titleBarCloseButton",	true,								ezui_type_bool);
ezUI_add_prop("titleBarGrabEnabled",	true,								ezui_type_bool);


ezUI_add_prop("titleBarText",			"",									ezui_type_string);
ezUI_add_prop("titleBarTextCenter",		true,								ezui_type_bool);
ezUI_add_prop("titleBarTextColor",		ezui_color_text_secondary,			ezui_type_real);
ezUI_add_prop("titleBarTextSize",		10,									ezui_type_int);
ezUI_add_prop("titleBarTextFont",		fnt_ezRoomEditor_default,					ezui_type_any);

ezUI_add_prop("onClose",				[del, id],							ezui_type_callable);

cursor_grab = false;
cursor_offset = [0, 0];