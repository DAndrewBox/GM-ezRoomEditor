// show_debug_overlay(true);

#region Constants
#macro	__EZUI_TEXT_FONT_SIZE	font_get_size(fnt_ezRoomEditor_default)

// Component types
#macro	ezui_type_bool					__EZUI_TYPES.BOOLEAN
#macro	ezui_type_string				__EZUI_TYPES.STRING
#macro	ezui_type_real					__EZUI_TYPES.REAL
#macro	ezui_type_int					__EZUI_TYPES.INT
#macro	ezui_type_struct				__EZUI_TYPES.STRUCT
#macro	ezui_type_array					__EZUI_TYPES.ARRAY
#macro	ezui_type_instance				__EZUI_TYPES.ASSET
#macro	ezui_type_callable				__EZUI_TYPES.CALLABLE
#macro	ezui_type_color					__EZUI_TYPES.COLOR
#macro	ezui_type_any					__EZUI_TYPES.ANY

#macro	ezui_color_text_primary			#f8f8f2
#macro	ezui_color_text_secondary		#6272a4
#macro	ezui_color_background_primary	#282a36
#macro	ezui_color_background_secondary	#44475a
#macro	ezui_color_highlight_primary	#bd93f9
#macro	ezui_color_highlight_secondary	#ff79c6

#macro	ezui_charset_all				__EZUI_CHARSETS.ALL
#macro	ezui_charset_text_no_special	__EZUI_CHARSETS.TEXT_ONLY
#macro	ezui_charset_numbers			__EZUI_CHARSETS.NUMBERS_ONLY
#macro	ezui_charset_text				__EZUI_CHARSETS.TEXT_SPECIAL

#endregion

#region Enums
enum __EZUI_BUTTON_STATE {
	DEFAULT,
	HOVER,
	CLICK,
	FOCUS,
	DISABLED,
}

enum __EZUI_MODAL_STATE {
	FOCUS,
	LOST_FOCUS
}

enum __EZUI_INPUT_STATE {
	DEFAULT,
	HOVER,
	FOCUS,
	DISABLED,
}

enum __EZUI_TYPES {
	BOOLEAN,
	STRING,
	REAL,
	INT,
	STRUCT,
	ARRAY,
	ASSET,
	CALLABLE,
	COLOR,
	ANY,
}

enum __EZUI_CHARSETS {
	ALL,
	TEXT_ONLY,
	TEXT_SPECIAL,
	NUMBERS_ONLY,
}
#endregion