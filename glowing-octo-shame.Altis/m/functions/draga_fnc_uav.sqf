
if (_this call m_fnc_isUAV) then {
	{
			private["_veh"];
	    _veh = vehicle _x;
			{
					if ([_this, "VIEW", _veh] checkVisibility [getPosASL _this, getPosASL _veh] > 0) then {
			    	_x reveal _veh;
					};
			} forEach allGroups;
	} forEach (position _this nearEntities 5000);
};
