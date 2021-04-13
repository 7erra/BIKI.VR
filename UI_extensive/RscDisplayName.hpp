class TAG_RscDisplayName
{
	idd = IDD_TAG_RSCDISPLAYNAME;
	onLoad = ["onLoad", _this] call TAG_fnc_RscDisplayName;
	class ControlsBackground
	{
		class Title: RscText
		{
			idc = -1;
			text = "Hello World";
			shadow = 0;
			x = GUI_GRID_CENTER_X + 5 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 3.9 * GUI_GRID_CENTER_H;
			w = 30 * GUI_GRID_CENTER_W;
			h = 1 * GUI_GRID_CENTER_H;
			colorBackground[] = GUI_BCG_COLOR;
		};
		class Background: RscText
		{
			idc = -1;
			x = GUI_GRID_CENTER_X + 5 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 5 * GUI_GRID_CENTER_H;
			w = 30 * GUI_GRID_CENTER_W;
			h = 15 * GUI_GRID_CENTER_H;
			colorBackground[] = {0,0,0,0.8};
		};
	};
	class Controls
	{
		class HelloWorld: RscStructuredText
		{
			idc = IDC_TAG_RSCDISPLAYNAME_HELLOWORLD;
			text = "Hello world from a dialog that I created! Here is a test image:";
			x = GUI_GRID_CENTER_X + 5.1 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 5.1 * GUI_GRID_CENTER_H;
			w = 29.8 * GUI_GRID_CENTER_W;
			h = 1 * GUI_GRID_CENTER_H;
		};
		class TestImage: RscPicture
		{
			idc = IDC_TAG_RSCDISPLAYNAME_TESTIMAGE;
			text = "\a3\ui_f\data\IGUI\RscTitles\HealthTextures\screen_blood_1_ca.paa";
			x = GUI_GRID_CENTER_X + 15 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 6.2 * GUI_GRID_CENTER_H;
			w = 10 * GUI_GRID_CENTER_W;
			h = 10 * GUI_GRID_CENTER_H;
		};
		class MoveLeft: RscButtonMenu
		{
			idc = IDC_TAG_RSCDISPLAYNAME_MOVELEFT;
			text = "Move Left";
			x = GUI_GRID_CENTER_X + 10 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 16.3 * GUI_GRID_CENTER_H;
			w = 5 * GUI_GRID_CENTER_W;
			h = 1 * GUI_GRID_CENTER_H;
		};
		class MoveRight: MoveLeft
		{
			idc = IDC_TAG_RSCDISPLAYNAME_MOVERIGHT;
			text = "Move Right";
			x = GUI_GRID_CENTER_X + 25 * GUI_GRID_CENTER_W;
		};
		class Okay: RscButtonMenuOK
		{
			x = GUI_GRID_CENTER_X + 5 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 20.1 * GUI_GRID_CENTER_H;
			w = 10 * GUI_GRID_CENTER_W;
			h = 1 * GUI_GRID_CENTER_H;
		};
		class Cancel: RscButtonMenuCancel
		{
			x = GUI_GRID_CENTER_X + 25 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 20.1 * GUI_GRID_CENTER_H;
			w = 10 * GUI_GRID_CENTER_W;
			h = 1 * GUI_GRID_CENTER_H;
		};
	};
};
