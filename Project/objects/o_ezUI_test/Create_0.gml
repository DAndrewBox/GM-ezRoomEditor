/// @description Test UI
var _createModal = function() {
	static _modals_count = 0;
	var _modal_w = 200;
	var _modal_h = 100;
	
	ezUI_create_modal({
		x: room_width / 2 - _modal_w / 2,
		y: room_height / 2 - _modal_h / 2,
		depth: -10 - _modals_count * 5,
		width: _modal_w,
		height: _modal_h,
		modalText: "Lorem Ipsum bla bla\nthis is a testing text\nlololololololol",
		modalTextAlign: fa_center,
		titleBarText: "Test modal",
		titleBarTextCenter: false,
	});
	
	_modals_count++;
}


ezUI_create_text({
	x: room_width / 2,
	y: 128,
	text: "Hello World",
	size: 10
});

ezUI_create_button(
	{
		x: room_width / 4,
		y: 256,
		width: 220,
		text: "Click me!",
		onClick: _createModal,
	},
	{
		color: ezui_color_highlight_primary,
		textColor: ezui_color_text_primary,
	},
	{
		color: ezui_color_highlight_secondary,
		textColor: ezui_color_text_primary,
	}
);

/*ezUI_create_input({
	x: 400,
	y: 400,
});
del();
*/