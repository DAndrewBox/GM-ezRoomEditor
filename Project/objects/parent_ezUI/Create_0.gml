/// @description Setup
/*
	@internal
	UUID	{str}	Unique component identifier
	
	@props
	x		{real}	Position x
	y		{real}	Position y
	depth	{int}	z-index
*/

__UUID = uuid_v4();
props		= {};

ezUI_add_prop("x",		0,	ezui_type_real);
ezUI_add_prop("y",		0,	ezui_type_real);
ezUI_add_prop("depth",	0,	ezui_type_int);

prevProps	= variable_clone(props);
children	= [];