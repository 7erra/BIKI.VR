#undef CT_STATIC
#define _Y(H) H * GUI_GRID_CENTER_H
#define BTN_CT(CTYPE, IDC, Y)\
class CT_##CTYPE: CT_STATIC\
{\
	idc = __EVAL(100 + IDC);\
	text = IDC ##CT_##CTYPE;\
	y = _Y(Y);\
};

class RscDisplayExportGUITypes
{
	idd = -1;
	onLoad = "[""onLoad"", _this] execVM ""ui\s\RscDisplayExportGUITypes.sqf"";";
	class controlsBackground
	{
		class Back: RscText
		{
			colorBackground[] = {0,0,0,0.8};
			x = GUI_GRID_CENTER_X + 0 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 0 * GUI_GRID_CENTER_H;
			w = 40 * GUI_GRID_CENTER_W;
			h = 25 * GUI_GRID_CENTER_H;
		};
	};
	class controls
	{
		class GroupTable: RscControlsGroup
		{
			idc = -1;
			x = GUI_GRID_CENTER_X + 0.1 * GUI_GRID_CENTER_W;
			y = GUI_GRID_CENTER_Y + 0.1 * GUI_GRID_CENTER_H;
			w = 12 * GUI_GRID_CENTER_W + 0.028;
			h = GUI_GRID_CENTER_HAbs - 0.2 * GUI_GRID_CENTER_H;
			class controls
			{
				class CT_STATIC: RscButtonMenu
				{
					idc = 100;
					text = "0 CT_STATIC";
					x = 0;
					y = 0;
					w = 12 * GUI_GRID_CENTER_W;
					h = 1 * GUI_GRID_CENTER_H;
				};
				BTN_CT(BUTTON, 1, 1.2)
				BTN_CT(EDIT, 2, 2.3)
				BTN_CT(SLIDER, 3, 3.4)
				BTN_CT(COMBO, 4, 4.5)
				BTN_CT(LISTBOX, 5, 5.6)
				BTN_CT(TOOLBOX, 6, 6.7)
				BTN_CT(CHECKBOXES, 7, 6.7)
				BTN_CT(PROGRESS, 8, 7.8)
				BTN_CT(HTML, 9, 8.9)
				BTN_CT(ACTIVETEXT, 11, 10)
				BTN_CT(TREE, 12, 11.1)
				BTN_CT(STRUCTURED_TEXT, 13, 12.2)
				BTN_CT(CONTROLS_GROUP, 15, 13.3)
				BTN_CT(SHORTCUTBUTTON, 16, 14.4)
				BTN_CT(XLISTBOX, 42, 15.5)
				BTN_CT(XSLIDER, 43, 16.6)
				BTN_CT(XCOMBO, 44, 17.7)
				BTN_CT(ANIMATED_TEXTURE, 45, 18.8)
				BTN_CT(MENU_STRIP, 47, 19.9)
				BTN_CT(CHECKBOX, 77, 21)
				BTN_CT(LINEBREAK, 98, 22.1)
				BTN_CT(USER, 99, 23.2)
				BTN_CT(MAP_MAIN, 101, 24.3)
				BTN_CT(LISTNBOX, 102, 25.4)
			};
		};
		class GroupOutput: RscControlsGroup
		{
			x = GUI_GRID_CENTER_X + 12.1 * GUI_GRID_CENTER_W + 0.028;
			y = GUI_GRID_CENTER_Y + 0.1 * GUI_GRID_CENTER_H;
			w = (40-12.2) * GUI_GRID_CENTER_W - 0.028;
			h = GUI_GRID_CENTER_HAbs - 0.2 * GUI_GRID_CENTER_H;
			class controls
			{
				class Output: RscEdit
				{
					idc = 900;
					font = "EtelkaMonospacePro";
					sizeEx = GUI_TEXT_SIZE_SMALL;
					canModify = 0;
					style = ST_MULTI;
					colorBackground[] = {0.1,0.1,0.1,1};
					x = 0;
					y = 0;
					w = (40-12.2) * GUI_GRID_CENTER_W - 0.028;
					h = 1;
				};
			};
		};
	};
};
#define CT_STATIC 0