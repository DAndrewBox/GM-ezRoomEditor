#region Variable types
#macro	ezre_type_bool			__EZRE_TYPES.BOOLEAN
#macro	ezre_type_string		__EZRE_TYPES.STRING
#macro	ezre_type_string_long	__EZRE_TYPES.STRING_LONG
#macro	ezre_type_real			__EZRE_TYPES.REAL
#macro	ezre_type_int			__EZRE_TYPES.INT
#macro	ezre_type_struct		__EZRE_TYPES.STRUCT
#macro	ezre_type_array			__EZRE_TYPES.ARRAY
#macro	ezre_type_color			__EZRE_TYPES.COLOR_RGB
#macro	ezre_type_color_rgba	__EZRE_TYPES.COLOR_RGBA
#macro	ezre_type_asset_sprite	__EZRE_TYPES.ASSET_SPRITE
#macro	ezre_type_asset_script	__EZRE_TYPES.ASSET_SCRIPT
#macro	ezre_type_asset_object	__EZRE_TYPES.ASSET_OBJECT
#macro	ezre_type_any			__EZRE_TYPES.ANY
#endregion

#region Misc
#macro	__EZRE_CONTROLLER		o_ezRoomEditor_Controller
#endregion

#region Enums
enum __EZRE_TYPES {
	BOOLEAN,
	STRING,
	STRING_LONG,
	REAL,
	INT,
	STRUCT,
	ARRAY,
	COLOR_RGB,
	COLOR_RGBA,
	ASSET_SPRITE,
	ASSET_SCRIPT,
	ASSET_OBJECT,
	ANY,
}

enum __EZRE_MODAL_STATES {
	OPEN,
	APPEAR,
	DISAPPEAR,
}
#endregion