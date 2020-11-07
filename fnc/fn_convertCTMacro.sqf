#include "\a3\ui_f\hpp\defineResincl.inc"
/*
	Author: Terra

	Description:
	Converts a number or a string to its control type macro or value counterpart.

	Parameter(s):
		0	STRING/NUMBER - Macro or number of the control type
	
	Returns:
		NUMBER 	- Value of the macro when input was string
		STRING 	- Name of the macro when input was number
		If no match was found it will return "" or -1

	Examples:
	[0] call BIKI_fnc_convertCTMacro; // -> "CT_STATIC"
	["CT_STATIC"] call BIKI_fnc_convertCTMacro; // -> 0
	[-1] call BIKI_fnc_convertCTMacro; // -> ""
	["CT_THISDOESNTEXIST"] call BIKI_fnc_convertCTMacro; // -> -1
*/
params ["_ct"];
private _dictCTs = [
	//Macro, Value
	["CT_STATIC", CT_STATIC],
	["CT_BUTTON", CT_BUTTON],
	["CT_EDIT", CT_EDIT],
	["CT_SLIDER", CT_SLIDER],
	["CT_COMBO", CT_COMBO],
	["CT_LISTBOX", CT_LISTBOX],
	["CT_TOOLBOX", CT_TOOLBOX],
	["CT_CHECKBOXES", CT_CHECKBOXES],
	["CT_PROGRESS", CT_PROGRESS],
	["CT_HTML", CT_HTML],
	["CT_STATIC_SKEW", CT_STATIC_SKEW],
	["CT_ACTIVETEXT", CT_ACTIVETEXT],
	["CT_TREE", CT_TREE],
	["CT_STRUCTURED_TEXT", CT_STRUCTURED_TEXT],
	["CT_CONTEXT_MENU", CT_CONTEXT_MENU],
	["CT_CONTROLS_GROUP", CT_CONTROLS_GROUP],
	["CT_SHORTCUTBUTTON", CT_SHORTCUTBUTTON],
	["CT_HITZONES", CT_HITZONES],
	["CT_CONTROLS_TABLE", CT_CONTROLS_TABLE],
	["CT_XKEYDESC", CT_XKEYDESC],
	["CT_XBUTTON", CT_XBUTTON],
	["CT_XLISTBOX", CT_XLISTBOX],
	["CT_XSLIDER", CT_XSLIDER],
	["CT_XCOMBO", CT_XCOMBO],
	["CT_ANIMATED_TEXTURE", CT_ANIMATED_TEXTURE],
	["CT_OBJECT", CT_OBJECT],
	["CT_OBJECT_ZOOM", CT_OBJECT_ZOOM],
	["CT_OBJECT_CONTAINER", CT_OBJECT_CONTAINER],
	["CT_OBJECT_CONT_ANIM", CT_OBJECT_CONT_ANIM],
	["CT_LINEBREAK", CT_LINEBREAK],
	["CT_USER", CT_USER],
	["CT_MAP", CT_MAP],
	["CT_MAP_MAIN", CT_MAP_MAIN],
	["CT_LISTNBOX", CT_LISTNBOX],
	["CT_ITEMSLOT", CT_ITEMSLOT],
	["CT_CHECKBOX", CT_CHECKBOX],
	["CT_VEHICLE_DIRECTION", CT_VEHICLE_DIRECTION]
];

{
	_x params ["_macro", "_value"];
	if (_macro isEqualTo _ct) exitWith {_value};
	if (_value isEqualTo _ct) exitWith {_macro};
	if (_ct isEqualType "") then {-1} else {""};
} forEach _dictCTs;