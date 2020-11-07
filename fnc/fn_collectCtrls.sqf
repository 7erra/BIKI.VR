#define BREAKPOINT if true exitWith {}
_defcts = [];
for "_i" from 0 to 105 do {_defcts pushBack _i};
params [
	["_cts", _defcts, [[], 1]],
	["_filter", {getNumber(_x>>"type") in _cts}],
	["_isDebug", false]
];
_mainCfg = param[3, [configFile, missionConfigFile] select _isDebug];
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
_ctrls = _ctrls select _filter;
_ctrls