/*
    Author: Terra
    
    Description:
		Generates the entire BIKI page for an entire control type. Some values 
		have to be manually added, for example the attributes descriptions and 
		the example classes. When the function is executed unscheduled, the game
		will freeze and no loading screen is shown.
		IMPORTANT: THIS FUNCTION IS FOR THE INITAL PAGE CREATION ONLY.
    
    Parameter(s):
    	0:	NUMBER/STRING - Macro or number of the control type

    Returns:
    	nil - Page content is copied to clipboard.

	Example(s):
		[0] execVM "fnc\generateCTPage.sqf";
		// same as:
		["CT_STATIC"] execVM "fnc\generateCTPage.sqf";
*/

params ["_ct"];

private ["_ctMacro", "_ctNumber"];
if (_ct isEqualType 0) then {
	_ctMacro = [_ct] call BIKI_fnc_convertCTMacro;
	_ctNumber = _ct;
} else {
	_ctMacro = _ct;
	_ctNumber = [_ct] call BIKI_fnc_convertCTMacro;
};
if (_ctNumber == -1 or _ctMacro == "") exitWith {
	["[generateCTPage.sqf] No such control type in list: [ %1 | %2 ]", _ctMacro, _ctNumber] call BIS_fnc_error;
};

_content = [
	"{{CT|intro",
	format ["|macro = %1", _ctMacro],
	format["|value = %1", _ctNumber],
	"|description = Informative text about this control type.",
	"|gallery=",
	"|commands =",
	"* command group CT",
	"|events =",
	"* events of this CT",
	"}}",
	"",
	"{{CT|abc start}}",
	[_ct] call compile preprocessFileLineNumbers "fnc\generateCTAttributes.sqf",
	"{{CT|abc end}}",
	"",
	"{{CT|examples}}",
	"=== RscExample ===",
	"<syntaxhighlight lang=""cpp"">",
	"//TODO",
	"</syntaxhighlight>",
	"",
	"[[Category: Dialogs]]"
];

_content = _content joinString endl;
copyToClipboard _content;