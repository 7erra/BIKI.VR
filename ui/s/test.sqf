params ["_ctrl"];
_display = ctrlParent _ctrl;
while {!isNull _display} do {
	ctrlAngle _ctrl params ["_a", "_cX", "_cY"];
	_ctrl ctrlSetAngle [_a+1, _cX, _cY];
	_ctrl ctrlCommit (1/360);
	waitUntil {ctrlCommitted _ctrl OR isNull _ctrl};
};