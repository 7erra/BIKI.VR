params["_ct"];
_allCtrlCfgs = [_ct] call BIKI_fnc_collectCtrls;
_outf = format["P:\biki\ui_classes\%1_CT.hpp",_ct];
_outstr = "";
_allCtrlCfgs apply {
	_xcfg = _x;
	_classStr = [_xcfg] call BIKI_fnc_configToString;
	_outstr = _outstr + toString[10] + _classStr;
};
if (count _outstr > 0) then {
	["write_to_file", [_outf, _outstr, "a"]] call BIKI_fnc_pyUtils;
};