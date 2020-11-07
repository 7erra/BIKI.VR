class TestDisplay
{
	idd = -1;
	class controls
	{
		class Background: RscText
		{
			idc = -1;
			x = -1 * GUI_GRID_W;
			y = -1 * GUI_GRID_H;
			w = 12 * GUI_GRID_W;
			h = 3 * GUI_GRID_H;
			colorBackground[] = {0, 0, 0, 1};
		};
		class TestControl: RscSlider
		{
			idc = -1;
			//onLoad = _this execVM "ui\s\test.sqf";
			text = "Hello world";
			x = 0;
			y = 0;
			w = 10 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;

			sliderStep = 1;
			sliderRange[] = {0,1};
		};
		class SecControl: RscButton
		{
			x = 0.5;
			y = 0;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
	};
};