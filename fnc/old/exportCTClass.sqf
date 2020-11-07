#include "\a3\ui_f\hpp\defineResincl.inc"
_defcts = [];
for "_i" from 0 to 105 do {_defcts pushBack _i};
params [
	["_cts", _defcts, [[], 1]],
	["_isDebug", false]
];
_mainCfg = param[2, [configFile, missionConfigFile] select _isDebug];
if (!_isDebug) then {startLoadingScreen [""]};
if !(_cts isEqualType []) then {_cts = [_cts]};

//--- Get all UIs
private _guiCond = 
	"isNumber(_x >> 'idd') && "+
	"(isClass(_x >> 'controls') OR isClass(_x>>'controlsBackground'))"
;
private _guis = 
	(_guiCond configClasses (_mainCfg)) +
	(_guiCond configClasses (_mainCfg >> "RscTitles"))
;
//--- Get the controls from the UIs
_ctrls = [];
_guis apply {
	_ctrls append (
		("isNumber(_x>>'type')" configClasses (_x >> "controls")) +
		("isNumber(_x>>'type')" configClasses (_x >> "controlsBackground")) +
		("isNumber(_x>>'type')" configClasses (_x >> "objects"))
	)
};
_fncIterateControls = {
	//--- Search for controls groups iteratively
	params["_ctrls"];
	if (count _ctrls == 0) exitWith {[]};
	private _newCtrls = [];
	_ctrls apply {
		_newCtrls append ("isNumber(_x>>'type')" configClasses (_x >> "controls"))
	};
	_ctrls + ([_newCtrls] call _fncIterateControls)
};
_ctrls = [_ctrls] call _fncIterateControls;
_ctrls = _ctrls select {getNumber(_x>>"type") in _cts};
//--- Extract base classes
_baseClasses = [];
_ctrls apply {
	private _xctrl = _x;
	private _parents = ([_xctrl] call BIS_fnc_returnParents) select {
		count(configHierarchy(_x)) == 2
	};
	_parents apply {
		diag_log _x;
		private _xparent = _x;
		if !(_xparent in _baseClasses) then {
			_baseClasses pushBackUnique _xparent;
			private _ccfg = _xparent call BIKI_fnc_configExtractor;
			[
				"write_to_file", 
				[
					format["P:\biki\ui_classes\CT_%1.hpp", getNumber(_xctrl>>"type")], 
					_ccfg, 
					"a"
				]
			] call BIKI_fnc_bikiUtils;
		};
	};
};
