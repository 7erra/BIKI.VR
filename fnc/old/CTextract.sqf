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

//--- Extract all data according to the control type
//--- and print it to a json file via Pythia
_dir = (getMissionPath "") + "dumps\cts";
_dir = (_dir splitString "\") joinString "\\";
_excludeLst = loadFile "dumps\cts\excludeatts.txt";
_excludeLst = (_excludeLst splitString endl) apply {toLower _x};
{
	private _xctrl = _x;
	private _xct = getNumber(_xctrl>>"type");
	private _xdata = [_xct];
	_props = configProperties[_xctrl, "true", true];
	_props = _props select {!(toLower configName _x in _excludeLst)};
	_props apply {
		private _xxprop = _x;
		// _xxdata format: [attribute, value, type]
		_xxname = configName _xxprop;
		private _xxData = switch true do {
			case isNumber(_xxprop):{
				_xxvalue = getNumber(_xxprop);
				[
					_xxvalue,	// value
					"Number"	// type
				]
			};
			case isText(_xxprop):{
				_xxvalue = getText(_xxprop);
				[
					_xxvalue,
					"String"
				]
			};
			case isArray(_xxprop):{
				_xxvalue = getArray(_xxprop);
				[
					_xxvalue,
					"Array"
				]
			};
			case isClass(_xxprop):{
				_xxvalue = _xxname;
				[
					_xxvalue,
					"Class"
				]
			};
		};
		[
			"biki_utils_py.ct_write_to_json",
			[_dir, _xct, _xxname] + _xxData
		] call py3_fnc_callExtension;
		[_dir, _xct, _xxname] + _xxData
	};
	if !(_isdebug) then {progressLoadingScreen (_forEachIndex/(count _ctrls))};
} forEach _ctrls;
endLoadingScreen;