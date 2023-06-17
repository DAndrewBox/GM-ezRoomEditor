/// @description 
var _xscale = gui_width() / ezRoomEditor_get_camera_width();
var _yscale = gui_height() / ezRoomEditor_get_camera_height();
var _x = x * _xscale;
var _y = bbox_top * _yscale;
draw_set_font(fnt_ezRoomEditor_default);
draw_set_color(COLOR_WITH_ALPHA);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_text(_x, _y, string(MESSAGE, name, age, desc, test_options[0] ? "like" : "dislike", test_options[1] ? "love" : "hate"));