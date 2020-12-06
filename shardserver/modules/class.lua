--[[
	Shard Engine
	Developed by Averice.
]]--

_shardClass = {}
_shardClass.__index = _shardClass;

function class(nme)
	if( _G[nme] ) then
		print("Class: "..nme.." already exists.");
		return;
	end
	_G[nme] = {}
	setmetatable(_G[nme], _shardClass)
	_G[nme].istype = nme;
	return _G[nme];
end

-- Really no reason for the shardClass metatable but it provides nice looking functionality'
--[[ 	class "CAnimatedEntity" : extends "CBaseEntity"  	<-- is now correct syntax	 ]]--
function _shardClass:extends(superclass)
	if( _G[superclass] ) then
		self.parent = superclass;
		self.__index = _G[superclass];
	end
end

function new(class)
	if( _G[class] ) then
		local newClass = {}
		setmetatable(newClass, _G[class]);
		for k, v in pairs(_G[class]) do
			newClass[k] = v;		-- For some reason metamethods weren't being accessed properly, here's a hacky fix.
		end
		if( newClass.Init ) then
			newClass:Init();
		end
		return newClass;
	end
	print("Class: "..class.." does not exist.");
end


