﻿{
	_x allowDamage false;
	_x setVariable ["_noDelete",true];
}forEach(allMissionObjects 'MASH')+(allMissionObjects 'ReammoBox_F')+(allMissionObjects 'WarfareBCamp'); 

{
	_x allowDamage false;
	//_x spawn m_fnc_mobileHQ_init;
	_x setVariable ["_noDelete",true];
}forEach (allMissionObjects "Warfare_HQ_base_unfolded");

Private ["_deleteList"];
while{true}do{
_deleteList=[];

{
	if ( isNil {_x getVariable "_noDelete"} ) then {
		_deleteList set [count _deleteList,_x];
	}else{
		if (!alive _x) then {
			Private ["_type","_pos","_dir","_veh"];
			_type = typeOf _x;
			_pos = getPos _x;
			_pos resize 2;
			_dir = getDir _x;
			deleteVehicle _x;
			_veh = createVehicle [_type, [0,0], [], 0, "NONE"];
			_veh allowDamage false;
			_veh setDir _dir;
			_veh setPos _pos;
			_veh setVariable ["_noDelete",true];
		};
	};
}
forEach (allMissionObjects 'MASH'); 

{
	if (!alive _x) then {
		if ( isNil {_x getVariable "_noDelete"} ) then {
			deleteVehicle _x;
		}else{
			Private ["_type","_pos","_dir","_veh"];
			_type = typeOf _x;
			_pos = getPos _x;
			_pos resize 2;
			_dir = getDir _x;
			deleteVehicle _x;
			_veh = createVehicle [_type, [0,0], [], 0, "NONE"];
			_veh allowDamage false;
			_veh setDir _dir;
			_veh setPos _pos;
			_veh setVariable ["_noDelete",true];
		};
	}else{
		if (getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "showweaponcargo") == 1) then {
			_deleteList set [count _deleteList,_x];
		}else{
			if ( isNil {_x getVariable "_noDelete"} ) then {
				_deleteList set [count _deleteList,_x];
			};
			_x call m_fnc_updateReammoBox;
		};
	};
}
forEach (allMissionObjects 'ReammoBox_F'); 

{
	_x setAmmoCargo 1;
	_x setRepairCargo 1;
	_x setFuelCargo 1;
}
forEach (allMissionObjects "Base_WarfareBVehicleServicePoint"); 

{
	if (!alive _x) then {
		deleteVehicle _x;
	};
} forEach (allMissionObjects "WarfareBBaseStructure")+(allMissionObjects "Warfare_HQ_base_unfolded")+(allMissionObjects "BASE_WarfareBFieldhHospital"); 

{
	private ["_objects"];
	_objects = allMissionObjects _x;
	{
		private ["_obj"];
		_obj = _x;
		{
			if( isNil {_x getVariable "_noDelete"} )then{
				if(!alive _x)then{
					deleteVehicle _x;
				}else{
					if(_obj distance _x < 10)then{
						if (({alive _x} count crew _x)==0) then{
							deleteVehicle _x;
						};
					};
				};
			};
		} forEach nearestObjects [getPos _obj, ["AllVehicles","Strategic"], 50]
	} forEach _objects;
} forEach HQ;
	
(_deleteList) call fnc_cleanup;
	sleep 1;
};
