--[[
	Shard Engine
	Developed by Averice.
]]--

hook = {}
local Hooks = {}

function hook.Add(n, u, f)	
	Hooks[n] = Hooks[n] or {}
	Hooks[n][u] = f;
end

function hook.GetTable()
	return Hooks
end

function hook.Remove(n, u)	
	Hooks[n] = Hooks[n] or {}
	if( Hooks[n][u] ) then
		Hooks[n][u] = nil
	end
end

function hook.Call(n, ...)
	if( Hooks[n] ) then
		for k,func in pairs(Hooks[n]) do
			func(...)
		end
	end
end