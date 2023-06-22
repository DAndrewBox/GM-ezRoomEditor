/// @description ImGui Modal draw
if (__EZRE_EDIT_ENABLED) {
	draw_set_alpha(1);
	draw_set_color(c_white);
	display_set_gui_maximize(__EZRE_GUI_SCALE, __EZRE_GUI_SCALE);
	ImGui.__Render();
}