--[[
	Shard Engine
	Developed by Averice.
]]--

command = {}

command.Commands = {}

function command.Create(com, func, desc)
	local newCom = {
		Func = func or function() end,
		Desc = desc or "No description"
	}
	command.Commands[tostring(com)] = newCom;
end

function command.Exists(com)
	return command.Commands[com] and true or false;
end

function command.Run(com, ...)
	if( command.Commands[com] ) then
		local succ, err = pcall(command.Commands[com].Func, ...);
		if( not succ ) then
			print("Command Error: ["..com.."] ".. err);
		end
	else
		print("Command '"..com.."' does not exist.");
	end
end

function command.GetAll()
	return command.Commands or {}
end
