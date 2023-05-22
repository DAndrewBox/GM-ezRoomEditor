/// @description 
var _xscale = gui_width() / ezRoomEditor_get_camera_width();
var _yscale = gui_height() / ezRoomEditor_get_camera_height();
var _x = x * _xscale;
var _y = bbox_top * _yscale;
draw_set_font(fnt_ezRoomEditor_default);
draw_set_color(ezui_color_text_primary);
draw_set_align(fa_center, fa_bottom);
draw_text_size(_x, _y, string(MESSAGE, name, age, desc, test_options[0] ? "like" : "dislike", test_options[1] ? "love" : "hate"), 10);